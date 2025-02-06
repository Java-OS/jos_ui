import 'package:flutter/material.dart';
import 'package:jos_ui/model/firewall/rule.dart';
import 'package:jos_ui/widget/key_value.dart';

enum Field {
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

  const Field(this.value);

  factory Field.fromValue(String value) {
    return Field.values.firstWhere((item) => item.value == value);
  }
}

class TcpExpression implements Expression {
  final Field field;
  final Operation operation;
  final dynamic value;

  TcpExpression(this.field, this.operation, this.value);

  factory TcpExpression.fromMap(Map<String, dynamic> map) {
    var operation = Operation.fromValue(map['match']['op']);
    var field = Field.fromValue(map['match']['left']['payload']['field']);
    var value = map['match']['right'];

    return TcpExpression(field, operation, value);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'match': {
        'op': operation.value,
        'left': {
          'payload': {'protocol': 'ether', 'field': field.value},
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
