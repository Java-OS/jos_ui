import 'package:flutter/material.dart';
import 'package:jos_ui/model/firewall/rule.dart';
import 'package:jos_ui/component/key_value.dart';

enum TcpField {
  ackseq('ackseq'),
  checksum('checksum'),
  doff('doff'),
  dport('dport'),
  flags('flags'),
  sequence('sequence'),
  sport('sport'),
  urgptr('urgptr'),
  window('window');

  final String value;

  const TcpField(this.value);

  factory TcpField.fromValue(String value) {
    return TcpField.values.firstWhere((item) => item.value == value);
  }
}

class TcpExpression implements Expression {
  final TcpField field;
  final Operation operation;
  final dynamic value;

  TcpExpression(this.field, this.operation, this.value);

  factory TcpExpression.fromMap(Map<String, dynamic> map) {
    var operation = Operation.fromValue(map['match']['op']);
    var field = TcpField.fromValue(map['match']['left']['payload']['field']);
    var value = map['match']['right'];

    return TcpExpression(field, operation, value);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'match': {
        'op': operation.value,
        'left': {
          'payload': {'protocol': 'tcp', 'field': field.value},
        },
        'right': value,
      },
    };
  }

  @override
  Widget display() {
    return KeyValue(k: field.value, v: value);
  }
}
