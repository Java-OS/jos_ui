import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/service/storage_service.dart';

class RestClient {
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
      if (statusCode == 204) {
        storeToken(response.headers);
        storeJvmNeedRestart(response.headers);
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
      if (statusCode == 204) {
        developer.log('Token is valid');
        storeToken(response.headers);
        storeJvmNeedRestart(response.headers);
        return true;
      }
      developer.log('Invalid token');
    } catch (e) {
      developer.log('[Dio Error] $rpc ${e.toString()}');
    }
    return false;
  }

  static Future<String?> rpc(RPC rpc, {Map<String, dynamic>? parameters}) async {
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
        return response.data;
      } else if (statusCode == 204) {
        return null;
      } else {
        String msg = jsonDecode(response.data)['message'];
        // if (context.mounted) displayWarning(msg, context, timeout: 5);
      }
    } catch (e) {
      if (rpc == RPC.systemReboot || rpc == RPC.jvmRestart || rpc == RPC.systemShutdown) {
        developer.log('Normal error by dio , The jvm shutdown before sending response');
      } else {
        developer.log('[Dio Error] $rpc ${e.toString()}');
      }
    }
    return null;
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
      developer.log('Receive header X-Jvm-Restart');
    }
  }
}
