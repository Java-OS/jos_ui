import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SecurityService {
  static final storage = FlutterSecureStorage();

  static Future<bool> login(String username, String password) async {
    var credential = base64.encode(utf8.encode('$username:$password'));
    var response = await http.get(Uri.parse("http://127.0.0.1:9091/api/login"),
        headers: {HttpHeaders.authorizationHeader: "Basic $credential"});

    if (response.headers.containsKey("token")) {
      var token = response.headers["token"];
      await storage.write(key: 'token', value: token);
      return Future(() => true);
    } else {
      return Future(() => false);
    }
  }

  static Future<bool> logout() {
    storage.delete(key: 'token');
    return Future(() => true);
  }
}
