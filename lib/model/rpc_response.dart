import 'dart:convert';

class ResponseDTO {
  bool success = false;
  int? error = -1;
  String? message = '';
  dynamic result;

  ResponseDTO(this.success, this.error, this.message, this.result);

  factory ResponseDTO.toObject(String response) {
    var json = jsonDecode(response);
    return ResponseDTO(json['success'], json['error'], json['message'], json['result']);
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
