import 'dart:convert';

import 'package:jos_ui/message_buffer.dart';

class Event {
  final String message;
  final SseConnectionType code;

  Event(this.message, this.code);

  factory Event.fromJson(String json) {
    var map = jsonDecode(json);
    var message = map['message'] ?? '';
    var eventCode = map['code'] ?? '';

    return Event(message, eventCode);
  }

  factory Event.fromBytes(List<int> bytes) {
    var str = utf8.decode(bytes);
    var map = jsonDecode(str);
    var message = map['message'] ?? '';
    var eventCode = map['code'] ?? '';

    return Event(message, eventCode);
  }
}
