import 'package:flutter/material.dart';
import 'package:jos_ui/model/firewall/rule.dart';
import 'package:jos_ui/component/key_value.dart';

class CounterStatement implements Statement {
  final int packets;
  final int bytes;

  CounterStatement(this.packets, this.bytes);

  factory CounterStatement.fromMap(Map<String, dynamic> map) {
    var packets = map['counter']['packets'] as int;
    var bytes = map['counter']['bytes'] as int;
    return CounterStatement(packets, bytes);
  }

  @override
  Widget display() {
    return KeyValue(
      k: 'packets',
      v: '$packets',
      keyBackgroundColor: Colors.blueGrey,
      valueBackgroundColor: Colors.teal[400]!,
      keyTextColor: Colors.white,
      valueTextColor: Colors.white,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'counter' : {}
    };
  }
}
