import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final storage = FlutterSecureStorage();

  BuildContext context;

  ApiService(this.context);

  Future<Object> rpc(int cmd) {
    return storage
        .read(key: "token")
        .then((token) => token ?? Navigator.of(context).pushReplacementNamed("/login"))
        .then((token) => http.get(
            Uri.parse("http://127.0.0.1:9091/api/rpc?cmd=$cmd"),
            headers: {"Token": "$token"}))
        .then((response) => response.statusCode == 401
            ? Navigator.of(context).pushReplacementNamed("/login")
            : response.body);
  }
}
