import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/service/storage_service.dart';

class RestApiService {
  static final dio = Dio();

  static String _baseLoginUrl() => "${StorageService.getItem('base_address') ?? 'http://127.0.0.1:9090'}/api/login";

  static String _baseRpcUrl() => "${StorageService.getItem('base_address') ?? 'http://127.0.0.1:9090'}/api/rpc";

  static Future<bool> login(String username, String password) async {
    developer.log('Login request [$username] [$password] [${_baseLoginUrl()}]');
    String authB64 = base64Encode(utf8.encode('$username:$password'));
    var header = {'Authorization': 'Basic $authB64'};
    developer.log('Credential send: [$header]');

    var response = await dio.get(_baseLoginUrl(), options: Options(headers: header, responseType: ResponseType.json, validateStatus: (_) => true));
    var statusCode = response.statusCode;
    if (statusCode == 200) {
      var token = response.headers['Authorization']!.first.split(' ')[1];
      StorageService.addItem('token', token);
      developer.log('Login success');
      return true;
    }
    developer.log('Login Failed');
    return false;
  }

  static Future<bool> checkLogin() async {
    var token = StorageService.getItem('token');
    if (token == null) return false;
    var header = {'Authorization': 'Bearer $token'};
    developer.log('Credential send: [$header]');

    var response = await dio.get(_baseLoginUrl(), options: Options(headers: header, responseType: ResponseType.json, validateStatus: (_) => true));
    var statusCode = response.statusCode;
    if (statusCode == 200) {
      developer.log('Token is valid');
      return true;
    }
    developer.log('Invalid token');
    return false;
  }

  static Future<bool> rpc(num rpc, Map<String, dynamic> parameters) async {
    developer.log('Request call rpc');
    var token = StorageService.getItem('token');
    if (token == null) navigatorKey.currentState?.pushReplacementNamed('/');
    var header = {
      'Authorization': 'Bearer $token',
      'x-rpc-code': ' $rpc',
    };
    developer.log('Credential send: [$token]');

    parameters['call'] = rpc;
    developer.log('Parameters : $parameters}');

    var response = await dio.post(_baseLoginUrl(), queryParameters: parameters, options: Options(headers: header, responseType: ResponseType.json, validateStatus: (_) => true));
    var statusCode = response.statusCode;
    if (statusCode == 200) {}
    developer.log('Finished');
    return false;
  }
}
