import 'dart:convert';

import 'package:jos_ui/model/log_level.dart';

class Log {
  final LogLevel level;
  final DateTime dateTime;
  final String thread;
  final String logger;
  final String message;

  Log(this.level, this.dateTime, this.thread, this.logger, this.message);

  factory Log.fromText(String str) {
    Map<String, dynamic> jsonObject = jsonDecode(str);
    var dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(jsonObject['timestamp']));
    var level = LogLevel.getValue(jsonObject['level']);
    var thread = jsonObject['thread'];
    var logger = jsonObject['logger'];
    var message = jsonObject['message'];

    return Log(level, dateTime, thread, logger, message);
  }
}
