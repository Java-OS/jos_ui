import 'dart:convert';

class RpcResponse {
  bool success = false;
  int? error = -1;
  String? message = '';
  dynamic result;

  RpcResponse(this.success, this.error, this.message, this.result);

  factory RpcResponse.toObject(String response) {
    var json = jsonDecode(response);
    return RpcResponse(json['success'], json['error'], json['message'], json['result']);
  }

  String toJson() {
    // return jsonEncode(thi);
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    data['result'] = result;
    return jsonEncode(data);
  }
}
