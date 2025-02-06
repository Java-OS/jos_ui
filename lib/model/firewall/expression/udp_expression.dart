import 'package:flutter/material.dart';
import 'package:jos_ui/model/firewall/rule.dart';
import 'package:jos_ui/widget/key_value.dart';

enum UdpField {
  checksum('checksum'),
  dport('dport'),
  length('length'),
  sport('sport');

  final String value;

  const UdpField(this.value);

  factory UdpField.fromValue(String value) {
    return UdpField.values.firstWhere((item) => item.value == value);
  }
}

class UdpExpression implements Expression {
  final UdpField field;
  final Operation operation;
  final dynamic value;

  UdpExpression(this.field, this.operation, this.value);

  factory UdpExpression.fromMap(Map<String, dynamic> map) {
    var operation = Operation.fromValue(map['match']['op']);
    var field = UdpField.fromValue(map['match']['left']['payload']['field']);
    var value = map['match']['right'];

    return UdpExpression(field, operation, value);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'match': {
        'op': operation.value,
        'left': {
          'payload': {'protocol': 'udp', 'field': field.value},
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
