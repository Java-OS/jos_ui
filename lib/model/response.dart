import 'dart:convert';

class JosResponse {
  final String? iv;
  final String? hash;
  final dynamic data;

  JosResponse({this.iv, this.hash, required this.data});

  factory JosResponse.toObject(String response) {
    var json = jsonDecode(response);
    var data = json['data'];
    var iv = json['iv'];
    var hash = json['hash'];
    return JosResponse(data: data, iv: iv, hash: hash);
  }

  Map<String, dynamic> toMap() {
    return {
      'iv': iv,
      'hash': hash,
      'data': data,
    };
  }
}
