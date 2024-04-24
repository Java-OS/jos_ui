import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:html';
import 'dart:typed_data';

import 'package:fetch_client/fetch_client.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/jvm_controller.dart';
import 'package:jos_ui/widget/toast.dart';
import 'package:jos_ui/model/log_level.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/protobuf/message-buffer.pb.dart';
import 'package:jos_ui/service/h5proto.dart';
import 'package:jos_ui/service/storage_service.dart';

enum UploadType {
  module,
  config,
  ssl;
}

class RestClient {
  static final JvmController jvmController = getx.Get.put(JvmController());
  static final _http = http.Client();
  static final _h5Proto = H5Proto.init();

  static String _baseH5ProtoUrl() => "${StorageService.getItem('server_ip_address') ?? 'http://127.0.0.1:7080'}/api/h5proto";

  static String _baseLoginUrl() => "${StorageService.getItem('server_ip_address') ?? 'http://127.0.0.1:7080'}/api/login";

  static String _baseRpcUrl() => "${StorageService.getItem('server_ip_address') ?? 'http://127.0.0.1:7080'}/api/rpc";

  static String _baseUploadUrl() => "${StorageService.getItem('server_ip_address') ?? 'http://127.0.0.1:7080'}/api/upload";

  static String _baseSseUrl() => "${StorageService.getItem('server_ip_address') ?? 'http://127.0.0.1:7080'}/api/sse";

  static String _baseDownloadUrl() => "${StorageService.getItem('server_ip_address') ?? 'http://127.0.0.1:7080'}/api/download";

  static Future<String?> sendEcdhPublicKey() async {
    developer.log('Request to send ecdh public key');
    _h5Proto.storePrivateKey();
    var publicKey = _h5Proto.exportPublicKey();

    try {
      Payload payload = Payload();
      payload.postJson = publicKey;
      var packet = Packet();
      packet.content = payload.writeToBuffer();
      var uri = Uri.parse(_baseH5ProtoUrl());
      var response = await _http.post(uri, body: packet.writeToBuffer());
      var statusCode = response.statusCode;
      if (statusCode == 200) {
        packet = Packet.fromBuffer(response.bodyBytes);
        var responsePayload = Payload.fromBuffer(packet.content);
        var serverPublicKey = jsonDecode(responsePayload.postJson)['public-key'];
        var captcha = jsonDecode(responsePayload.postJson)['captcha'];
        developer.log('Server public key $serverPublicKey');
        developer.log('Captcha $captcha');
        var publicKey = _h5Proto.bytesToPublicKey(base64Decode(serverPublicKey));
        _h5Proto.makeSharedSecret(publicKey);
        _h5Proto.removePrivateKey();

        storeToken(response.headers);
        developer.log('public key exchanged successful');
        return captcha;
      } else {
        developer.log('Exchange public key failed');
      }
    } catch (e) {
      developer.log('[Http Error] $rpc ${e.toString()}');
    }
  }

  static Future<bool> login(String username, String password, String salt) async {
    developer.log('Login request [$username] [$password] [${_baseLoginUrl()}]');
    StorageService.addItem('activation-key', salt.toUpperCase());
    var data = {
      'username': username,
      'password': password,
    };

    var token = StorageService.getItem('token');
    var headers = {'authorization': 'Bearer $token'};
    developer.log('Header send: [$headers]');

    var packet = await _h5Proto.encode(Payload(postJson: jsonEncode(data)));

    try {
      var response = await _http.post(Uri.parse(_baseLoginUrl()), body: packet.writeToBuffer(), headers: headers);
      var statusCode = response.statusCode;
      if (statusCode == 204) {
        storeToken(response.headers);
        developer.log('Login success');
        return true;
      }
      StorageService.removeItem('activation-key');
      developer.log('Login Failed');
    } catch (e) {
      developer.log('[Http Error] $rpc ${e.toString()}');
      StorageService.removeItem('activation-key');
    }
    return false;
  }

  static Future<Payload> rpc(RPC rpc, {Map<String, dynamic>? parameters}) async {
    developer.log('Request call rpc: [$rpc] [$parameters] [${_baseRpcUrl()}]');
    var token = StorageService.getItem('token');
    if (token == null) getx.Get.toNamed('/login');
    var headers = {'Authorization': 'Bearer $token'};
    developer.log('Header send: [$headers]');

    var data = parameters != null ? jsonEncode(parameters) : null;
    var packet = await _h5Proto.encode(Payload(postJson: data, metadata: Metadata(rpc: rpc.value)));

    // debugPrint('Parameters : ${jsonEncode(parameters)}');
    // debugPrint('IV : ${base64Encode(packet.iv)}');
    // debugPrint('Hash : ${base64Encode(packet.hash)}');
    // debugPrint('Content : ${base64Encode(packet.content)}');

    try {
      var response = await _http.post(Uri.parse(_baseRpcUrl()), body: packet.writeToBuffer(), headers: headers);
      var statusCode = response.statusCode;
      developer.log('Response received with http code: $statusCode');

      storeToken(response.headers);
      if (statusCode == 200) {
        return await decodeResponsePayload(response);
      } else if (statusCode == 204) {
        return await decodeResponsePayload(response);
      } else if (statusCode == 401) {
        getx.Get.offAllNamed(Routes.base.routeName);
      } else {
        var payload = await decodeResponsePayload(response);
        displayWarning(payload.metadata.message, timeout: 5);
      }
    } catch (e) {
      if (rpc == RPC.systemReboot || rpc == RPC.jvmRestart || rpc == RPC.systemShutdown) {
        developer.log('Normal error by http , The jvm going to shutdown before sending response');
      } else {
        developer.log('[Http Error] $rpc ${e.toString()}');
      }
    }
    return Payload(metadata: Metadata(success: false));
  }

  static void storeToken(Map<String, String> headers) {
    var authHeader = headers['authorization'];
    if (authHeader != null) {
      var token = authHeader.split(' ')[1];
      StorageService.addItem('token', token);
    }
  }

  static void storeJvmNeedRestart(bool doJvmRestart) {
    developer.log('Receive header X-Jvm-Restart with value: [$doJvmRestart]');
    doJvmRestart ? jvmController.enableRestartJvm() : jvmController.disableRestartJvm();
  }

  static Future<bool> upload(Uint8List bytes, String fileName, UploadType type, String? password) async {
    developer.log('selected file: $fileName');

    var token = StorageService.getItem('token');
    var headers = {
      'authorization': 'Bearer $token',
    };

    try {
      var request = http.MultipartRequest('POST', Uri.parse('${_baseUploadUrl()}/${type.name}'));
      request.headers.addAll(headers);
      var fileOrder = http.MultipartFile.fromBytes('file', bytes, filename: fileName);
      request.files.add(fileOrder);
      if (password != null) request.fields['password'] = password;
      var response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      displayError('Invalid ${type.name} file');
      return false;
    }
  }

  static Future<FetchResponse> sse(String packageName, LogLevel logLevel) async {
    developer.log('Start SSE Client [$packageName] [${logLevel.name}]');
    var token = StorageService.getItem('token');
    if (token == null) getx.Get.toNamed('/login');

    var header = {
      'authorization': 'Bearer $token',
      'Connection': 'keep-alive',
      'Content-type': 'text/event-stream',
    };

    developer.log('Header send: [$header]');

    var packet = await _h5Proto.encode(Payload(metadata: Metadata(logLevel: logLevel.name.toUpperCase(), logPackage: packageName)));

    var request = http.Request('POST', Uri.parse(_baseSseUrl()));
    request.bodyBytes = packet.writeToBuffer();
    request.headers.addAll(header);

    final FetchClient fetchClient = FetchClient(mode: RequestMode.cors);
    return fetchClient.send(request);
  }

  static Future<void> download(Map<String, String> parameters) async {
    developer.log('Download file: ');
    var token = StorageService.getItem('token');
    if (token == null) getx.Get.toNamed('/');
    var headers = {
      'Authorization': 'Bearer $token',
    };
    developer.log('Credential send: [$headers]');

    try {
      var data = jsonEncode(parameters);
      var packet = await _h5Proto.encode(Payload(postJson: data));

      var uri = Uri.parse(_baseDownloadUrl());

      final anchor = AnchorElement(href: '#')
        ..setAttribute('download', '')
        ..style.display = 'none';
      document.body!.append(anchor);

      // final request = await http.head(uri, headers: headers);
      final request = http.Request('POST', uri);
      request.headers.addAll(headers);
      request.bodyBytes = packet.writeToBuffer();

      final client = http.Client();
      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      final blob = Blob([response.bodyBytes]);
      final urlObject = Url.createObjectUrlFromBlob(blob);

      final contentDisposition = response.headers['content-disposition'];
      final filename = contentDisposition?.split('filename=')[1].replaceAll('"', '');

      anchor.href = urlObject;
      anchor.download = filename;
      anchor.click();
      anchor.remove();
      Url.revokeObjectUrl(urlObject);

      client.close();
    } catch (e) {
      developer.log('[Http Error] $rpc ${e.toString()}');
    }
  }

  static Future<Payload> decodeResponsePayload(http.Response response) async {
    var bodyBytes = response.bodyBytes;
    var packet = Packet.fromBuffer(bodyBytes);
    var iv = Uint8List.fromList(packet.iv);
    var content = Uint8List.fromList(packet.content);
    var payload = await _h5Proto.decode(content, iv);
    var metadata = payload.metadata;
    storeJvmNeedRestart(metadata.needRestart);
    return payload;
  }
}
