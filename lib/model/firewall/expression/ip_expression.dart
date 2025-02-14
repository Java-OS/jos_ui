import 'package:flutter/material.dart';
import 'package:jos_ui/model/firewall/rule.dart';
import 'package:jos_ui/component/key_value.dart';

enum IpField {
  checksum('checksum'),
  daddr('daddr'),
  dscp('dscp'),
  fragOff('frag-off'),
  hdrlength('hdrlength'),
  id('id'),
  length('length'),
  protocol('protocol'),
  saddr('saddr'),
  ttl('ttl'),
  version('version');

  final String value;

  const IpField(this.value);

  factory IpField.fromValue(String value) {
    return IpField.values.firstWhere((item) => item.value == value);
  }
}

class IpExpression implements Expression {
  final IpField field;
  final Operation operation;
  final String value;

  IpExpression(this.field, this.operation, this.value);

  factory IpExpression.fromMap(Map<String, dynamic> map) {
    var operation = Operation.fromValue(map['match']['op']);
    var field = IpField.fromValue(map['match']['left']['payload']['field']);
    var value = map['match']['right'];

    return IpExpression(field, operation, value);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'match': {
        'op': operation.value,
        'left': {
          'payload': {'protocol': 'ip', 'field': field.value},
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
