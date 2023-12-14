import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/jvm_controller.dart';
import 'package:jos_ui/dialog/toast.dart';
import 'package:jos_ui/model/RpcResponse.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/service/storage_service.dart';

class RestClient {
  static final JvmController jvmController = Get.put(JvmController());
  static final _dio = Dio();

  static String _baseLoginUrl() => "${StorageService.getItem('base_address') ?? 'http://127.0.0.1:7080'}/api/login";

  static String _baseRpcUrl() => "${StorageService.getItem('base_address') ?? 'http://127.0.0.1:7080'}/api/rpc";

  static Future<bool> login(String username, String password) async {
    developer.log('Login request [$username] [$password] [${_baseLoginUrl()}]');
    String authB64 = base64Encode(utf8.encode('$username:$password'));
    var header = {'Authorization': 'Basic $authB64'};
    developer.log('Credential send: [$header]');

    try {
      var response = await _dio.get(_baseLoginUrl(), options: Options(headers: header, responseType: ResponseType.json, validateStatus: (_) => true));
      var statusCode = response.statusCode;
      storeJvmNeedRestart(response.headers);
      if (statusCode == 204) {
        storeToken(response.headers);
        developer.log('Login success');
        return true;
      }
      developer.log('Login Failed');
    } catch (e) {
      // displayError('Failed connect to server');
      developer.log('[Dio Error] $rpc ${e.toString()}');
    }
    return false;
  }

  static Future<bool> checkLogin() async {
    developer.log('Check login [${_baseLoginUrl()}]');
    var token = StorageService.getItem('token');
    if (token == null) return false;
    var header = {'authorization': 'Bearer $token'};
    developer.log('Credential send: [$header]');

    try {
      var response = await _dio.get(_baseLoginUrl(), options: Options(headers: header, responseType: ResponseType.json, validateStatus: (_) => true));
      var statusCode = response.statusCode;
      storeJvmNeedRestart(response.headers);
      if (statusCode == 204) {
        developer.log('Token is valid');
        storeToken(response.headers);
        return true;
      }
      developer.log('Invalid token');
    } catch (e) {
      developer.log('[Dio Error] $rpc ${e.toString()}');
    }
    return false;
  }

  static Future<RpcResponse> rpc(RPC rpc, {Map<String, dynamic>? parameters}) async {
    developer.log('Request call rpc: [$rpc] [$parameters] [${_baseLoginUrl()}]');
    var token = StorageService.getItem('token');
    if (token == null) Get.toNamed('/');
    var header = {
      'authorization': 'Bearer $token',
      'x-rpc-code': '${rpc.value}',
    };
    developer.log('Credential send: [$header]');

    try {
      var response = await _dio.post(_baseRpcUrl(), data: parameters, options: Options(headers: header, responseType: ResponseType.plain, validateStatus: (_) => true));
      var statusCode = response.statusCode;
      developer.log('Response received with http code: $statusCode');
      storeJvmNeedRestart(response.headers);
      storeToken(response.headers);
      if (statusCode == 200) {
        return RpcResponse.toObject(response.data);
      } else if (statusCode == 204) {
        return RpcResponse(true, null, null, null);
      } else if (statusCode == 401) {
        Get.offAllNamed('/');
      } else {
        String msg = jsonDecode(response.data)['message'];
        displayWarning(msg, timeout: 5);
      }
    } catch (e) {
      if (rpc == RPC.systemReboot || rpc == RPC.jvmRestart || rpc == RPC.systemShutdown) {
        developer.log('Normal error by dio , The jvm going to shutdown before sending response');
      } else {
        developer.log('[Dio Error] $rpc ${e.toString()}');
      }
    }
    return RpcResponse(false, null, null, null);
  }

  static void storeToken(Headers headers) {
    var authHeader = headers['Authorization'];
    if (authHeader != null) {
      var token = authHeader.first.split(' ')[1];
      StorageService.addItem('token', token);
    }
  }

  static void storeJvmNeedRestart(Headers headers) {
    var jvmNeedRestart = headers['X-Jvm-Restart'];
    if (jvmNeedRestart != null) {
      developer.log('Receive header X-Jvm-Restart with value: [${jvmNeedRestart.first}]');
      jvmNeedRestart.first == 'true' ? jvmController.enableRestartJvm() : jvmController.disableRestartJvm();
    }
  }
}
