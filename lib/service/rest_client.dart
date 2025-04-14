import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:html';
import 'dart:typed_data';

import 'package:get/get.dart' as getx;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jos_ui/component/toast.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/jvm_controller.dart';
import 'package:jos_ui/controller/upload_download_controller.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/service/h5proto.dart';
import 'package:jos_ui/service/storage_service.dart';
import 'package:jos_ui/util/protobuf_utils.dart';
import 'package:pool/pool.dart';

class RestClient {
  static final UploadDownloadController _uploadDownloadController = Get.put(UploadDownloadController());
  static final JvmController _jvmController = Get.put(JvmController());
  static final _http = http.Client();
  static final _h5Proto = H5Proto.init();

  static Future<String?> sendEcdhPublicKey() async {
    var uri = Uri.parse(baseHandshakeUrl());
    developer.log('Request to send ecdh public key');
    _h5Proto.storePrivateKey();
    var publicKey = _h5Proto.exportPublicKey();

    try {
      var payloadBytes = ProtobufUtils.serializePayload(null, Uint8List.fromList(utf8.encode(publicKey)));
      var packetBytes = ProtobufUtils.serializePacket(null, null, payloadBytes);
      var response = await _http.post(uri, body: packetBytes);
      var statusCode = response.statusCode;
      if (statusCode == 200) {
        var packet = Packet(response.bodyBytes);
        var responsePayload = Payload(Uint8List.fromList(packet.payload!));
        var serverPublicKey = jsonDecode(utf8.decode(responsePayload.content!))['public-key'];
        var captcha = jsonDecode(utf8.decode(responsePayload.content!))['captcha'];
        developer.log('Server public key $serverPublicKey');
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
    return null;
  }

  static Future<bool> login(String username, String password, String salt) async {
    developer.log('Login request [$username] [$password] [${baseLoginUrl()}]');
    StorageService.addItem('activation-key', salt.toUpperCase());
    var data = {
      'username': username,
      'password': password,
    };

    var token = StorageService.getItem('token');
    var headers = {'authorization': 'Bearer $token'};
    developer.log('Header send: [$headers]');
    var bytes = Uint8List.fromList(utf8.encode(jsonEncode(data)));
    var packet = await _h5Proto.encode(ProtobufUtils.serializePayload(null, bytes));

    try {
      var response = await _http.post(Uri.parse(baseLoginUrl()), body: packet, headers: headers);
      var statusCode = response.statusCode;
      if (statusCode == 204) {
        storeToken(response.headers);
        developer.log('Login success');
        return true;
      }
      StorageService.removeItem('activation-key');
      developer.log('Login Failed');
      return false;
    } catch (e) {
      developer.log('[Http Error] $rpc ${e.toString()}');
      StorageService.removeItem('activation-key');
    }
    return false;
  }

  static Future<bool> verifyToken() async {
    var token = StorageService.getItem('token');
    var headers = {'authorization': 'Bearer $token'};
    developer.log('Header send: [$headers]');

    try {
      var response = await _http.post(Uri.parse(baseVerifyTokenUrl()), headers: headers);
      var statusCode = response.statusCode;
      if (statusCode == 204) {
        storeToken(response.headers);
        developer.log('Login success');
        return true;
      }
      StorageService.removeItem('activation-key');
      developer.log('Login Failed');
      return false;
    } catch (e) {
      developer.log('[Http Error] $rpc ${e.toString()}');
      StorageService.removeItem('activation-key');
    }
    return false;
  }

  static Future<Payload> rpc(Rpc rpc, {Map<String, dynamic>? parameters}) async {
    developer.log('Request call rpc: [$rpc] [$parameters] [${baseRpcUrl()}]');
    var token = StorageService.getItem('token');
    if (token == null) Get.toNamed('/login');
    var headers = {'Authorization': 'Bearer $token'};
    developer.log('Header send: [$headers]');

    var data = parameters != null ? Uint8List.fromList(utf8.encode(jsonEncode(parameters))) : null;
    var metadata = ProtobufUtils.serializeMetadata(null, rpc.value, null, null, null);
    var payload = ProtobufUtils.serializePayload(metadata, data);
    var packet = await _h5Proto.encode(payload);

    try {
      var response = await _http.post(Uri.parse(baseRpcUrl()), body: packet, headers: headers);
      var statusCode = response.statusCode;
      developer.log('Response received with http code: $statusCode');

      if (statusCode == 200) {
        storeToken(response.headers);
        return await decodeResponsePayload(response);
      } else if (statusCode == 204) {
        storeToken(response.headers);
        return await decodeResponsePayload(response);
      } else if (statusCode == 401) {
        Get.offAllNamed(Routes.base.path);
      } else {
        var payload = await decodeResponsePayload(response);
        displayWarning(payload.metadata!.message!, timeout: 5);
      }
    } catch (e) {
      if (rpc == Rpc.RPC_SYSTEM_REBOOT || rpc == Rpc.RPC_JVM_RESTART || rpc == Rpc.RPC_SYSTEM_SHUTDOWN) {
        developer.log('Normal error by http , The jvm going to shutdown before sending response');
      } else {
        developer.log('[Http Error] $rpc ${e.toString()}');
      }
    }
    var serializeMetadata = ProtobufUtils.serializeMetadata(false, null, null, null, null);
    return Payload(ProtobufUtils.serializePayload(serializeMetadata, null));
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
    doJvmRestart ? _jvmController.enableRestartJvm() : _jvmController.disableRestartJvm();
  }

  static Future<Payload> download(String path, String? password) async {
    developer.log('Download file: [$path]');
    var token = StorageService.getItem('token');
    if (token == null) Get.toNamed('/login');
    var headers = {'Authorization': 'Bearer $token'};
    developer.log('Header send: [$headers]');

    var parameters = {
      'file': path,
      'password': password,
    };

    var serializeMetadata = ProtobufUtils.serializeMetadata(false, null, null, null, null);
    var bytes = Uint8List.fromList(utf8.encode(jsonEncode(parameters)));
    var packet = await _h5Proto.encode(ProtobufUtils.serializePayload(serializeMetadata, bytes));

    try {
      var response = await _http.post(Uri.parse(baseDownloadUrl()), body: packet, headers: headers);
      var statusCode = response.statusCode;
      developer.log('Response received with http code: $statusCode');

      final blob = Blob([response.bodyBytes]);
      final urlObject = Url.createObjectUrlFromBlob(blob);

      final contentDisposition = response.headers['content-disposition'];
      final filename = contentDisposition?.split('filename=')[1].replaceAll('"', '');

      final anchor = AnchorElement(href: '#')
        ..setAttribute('download', '')
        ..style.display = 'none';
      document.body!.append(anchor);

      anchor.href = urlObject;
      anchor.download = filename;
      anchor.click();
      anchor.remove();
      Url.revokeObjectUrl(urlObject);
    } catch (e) {
      developer.log('[Http Error] $rpc ${e.toString()}');
    }
    var metadata = ProtobufUtils.serializeMetadata(false, null, null, null, null);
    return Payload(ProtobufUtils.serializePayload(metadata, null));
  }

  static Future<void> upload(String fileName, String targetPath, Uint8List bytes) async {
    var token = StorageService.getItem('token');
    if (token == null) Get.toNamed('/login');
    var headers = {'Authorization': 'Bearer $token'};

    int totalChunks = (bytes.length / chunkSize).ceil();
    final pool = Pool(10); // Max 10 concurrent uploads
    final futures = <Future>[];

    for (int i = 0; i < totalChunks; i++) {
      if (_uploadDownloadController.isCancel.value) break;

      final chunkIndex = i;
      futures.add(
        pool.withResource(
          () async {
            int start = chunkIndex * chunkSize;
            int end = start + chunkSize;
            if (end > bytes.length) end = bytes.length;

            Uint8List chunk = bytes.sublist(start, end);
            var serializeTransferBytes = ProtobufUtils.serializeTransfer(fileName, targetPath, totalChunks, chunkIndex, chunk, bytes.length);
            var serializeMetadata = ProtobufUtils.serializeMetadata(null, null, null, null, null);
            var serializePayload = ProtobufUtils.serializePayload(serializeMetadata, serializeTransferBytes);
            var packetBytes = await _h5Proto.encode(serializePayload);

            // Update progress
            _uploadDownloadController.percentage.value = (chunkIndex / totalChunks).toDouble();

            var response = await _http.post(
              Uri.parse(baseUploadUrl()),
              body: packetBytes,
              headers: headers,
            );
            developer.log('Chunk $fileName ${bytes.length} $chunkIndex/$totalChunks status:${response.statusCode}');
            if (response.statusCode != 200) {
              var payload = await decodeResponsePayload(response);
              throw Exception(payload.metadata!.message);
            }
          },
        ),
      );
    }

    await Future.wait(futures);
    if (!_uploadDownloadController.isCancel.value) {
      _uploadDownloadController.percentage.value = 1.0;
    }
  }

  static Future<Payload> decodeResponsePayload(http.Response response) async {
    var bodyBytes = response.bodyBytes;
    var packet = Packet(bodyBytes);
    var iv = Uint8List.fromList(packet.iv!);
    var cipher = Uint8List.fromList(packet.payload!);
    var payload = await _h5Proto.decrypt(cipher, iv);
    var metadata = payload.metadata;
    storeJvmNeedRestart(metadata!.needRestart);
    return payload;
  }
}
