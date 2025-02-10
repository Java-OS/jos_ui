import 'package:flutter/material.dart';
import 'package:jos_ui/model/firewall/rule.dart';
import 'package:jos_ui/widget/key_value.dart';

enum LogLevel {
  log('log'),
  emerg('emerg'),
  alert('alert'),
  crit('crit'),
  err('err'),
  warn('warn'),
  notice('notice'),
  info('info'),
  debug('debug');

  final String value;

  const LogLevel(this.value);

  factory LogLevel.fromValue(String value) {
    return LogLevel.values.firstWhere((item) => item.value == value);
  }
}

class LogStatement implements Statement {
  final LogLevel? level;
  final String? prefix;

  LogStatement(this.level, this.prefix);

  factory LogStatement.fromMap(Map<String, dynamic> map) {
    bool hasLevel = map['log'].containsKey('level') ;
    bool hasPrefix = map['log'].containsKey('prefix');
    if (hasLevel && hasPrefix) return LogStatement(LogLevel.fromValue(map['log']['level']), map['log']['prefix']);
    if (hasLevel) return LogStatement(LogLevel.fromValue(map['log']['level']), null);
    if (hasPrefix) return LogStatement(null, map['log']['prefix']);
    return LogStatement(null, null);
  }

  @override
  Widget display() {
    if (level != null) {
      return KeyValue(
        k: 'log',
        v: level!.name,
        keyBackgroundColor: Colors.blueGrey,
        valueBackgroundColor: Colors.teal[400]!,
        keyTextColor: Colors.white,
        valueTextColor: Colors.white,
      );
    } else {
      return Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          border: Border.all(width: 0.1, color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Text(
          'log',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      );
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'log': {'prefix': prefix, 'level': level?.value}
    };
  }
}
