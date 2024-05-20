import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:jos_ui/model/event_code.dart';

class Event {
  final String message;
  final EventCode code;

  Event(this.message, this.code);

  factory Event.fromJson(String json) {
    var map = jsonDecode(json);
    var message = map['message'] ?? '';
    var eventCode = EventCode.getValue(map['code'] ?? '');

    return Event(message, eventCode);
  }
}