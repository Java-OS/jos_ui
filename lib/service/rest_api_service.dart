import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jos_ui/service/storage_service.dart';
import 'dart:developer' as developer;

class RestApiService {
  static final dio = Dio();

  static String _baseLoginUrl() => "${StorageService.getItem('base_address') ?? 'http://127.0.0.1:9090'}/api/login";

  static String _baseRpcUrl() => "${StorageService.getItem('base_address') ?? 'http://127.0.0.1:9090'}/api/rpc";

  static Future<bool> login(String username, String password) async {
    developer.log('Login request [$username] [$password] [${_baseLoginUrl()}]');
    String authB64 = base64Encode(utf8.encode('$username:$password'));
    var header = {'Authorization': 'Basic $authB64'};
    developer.log('Credential send: [$header]');

    var response = await dio.get(_baseLoginUrl(), options: Options(headers: header, responseType: ResponseType.json,validateStatus: (_) => true));
    var statusCode = response.statusCode;
    if (statusCode == 200) {
      var token = response.headers['Token']!.first;
      StorageService.addItem('token', token);
      developer.log('Login success');
      return true;
    }
    developer.log('Login Failed');
    return false;
  }
}
