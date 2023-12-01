import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/service/storage_service.dart';

class RestApiService {
  static final dio = Dio();

  static String _baseLoginUrl() => "${StorageService.getItem('base_address') ?? 'http://127.0.0.1:7080'}/api/login";

  static String _baseRpcUrl() => "${StorageService.getItem('base_address') ?? 'http://127.0.0.1:7080'}/api/rpc";

  static Future<bool> login(String username, String password) async {
    developer.log('Login request [$username] [$password] [${_baseLoginUrl()}]');
    String authB64 = base64Encode(utf8.encode('$username:$password'));
    var header = {'Authorization': 'Basic $authB64'};
    developer.log('Credential send: [$header]');

    var response = await dio.get(_baseLoginUrl(), options: Options(headers: header, responseType: ResponseType.json, validateStatus: (_) => true));
    var statusCode = response.statusCode;
    if (statusCode == 202) {
      var token = response.headers['Authorization']!.first.split(' ')[1];
      StorageService.addItem('token', token);
      developer.log('Login success');
      return true;
    }
    developer.log('Login Failed');
    return false;
  }

  static Future<bool> checkLogin() async {
    developer.log('Check login [${_baseLoginUrl()}]');
    var token = StorageService.getItem('token');
    if (token == null) return false;
    var header = {'authorization': 'Bearer $token'};
    developer.log('Credential send: [$header]');

    var response = await dio.get(_baseLoginUrl(), options: Options(headers: header, responseType: ResponseType.json, validateStatus: (_) => true));
    var statusCode = response.statusCode;
    if (statusCode == 202) {
      developer.log('Token is valid');
      return true;
    }
    developer.log('Invalid token');
    return false;
  }

  static Future<String?> rpc(RPC rpc, {Map<String, dynamic>? parameters}) async {
    developer.log('Request call rpc: [$rpc] [$parameters] [${_baseLoginUrl()}]');
    var token = StorageService.getItem('token');
    if (token == null) navigatorKey.currentState?.pushReplacementNamed('/');
    var header = {
      'authorization': 'Bearer $token',
      'x-rpc-code': ' ${rpc.value}',
    };
    developer.log('Credential send: [$header]');

    var response = await dio.post(_baseRpcUrl(), queryParameters: parameters, options: Options(headers: header, responseType: ResponseType.plain, validateStatus: (_) => true));
    var statusCode = response.statusCode;
    if (statusCode == 200) {
      developer.log('Received data: [${response.data}]');
      return response.data;
    }

    return null;
  }
}
