import 'package:flutter/material.dart';
import 'package:jos_ui/model/firewall/rule.dart';
import 'package:jos_ui/component/key_value.dart';

enum EtherField {
  daddr('daddr'),
  saddr('saddr'),
  type('type');

  final String value;

  const EtherField(this.value);

  factory EtherField.fromValue(String value) {
    return EtherField.values.firstWhere((item) => item.value == value);
  }
}

class EtherExpression implements Expression {
  final EtherField field;
  final Operation operation;
  final dynamic value;

  EtherExpression(this.field, this.operation, this.value);

  factory EtherExpression.fromMap(Map<String, dynamic> map) {
    var operation = Operation.fromValue(map['match']['op']);
    var field = EtherField.fromValue(map['match']['left']['payload']['field']);
    var value = map['match']['right'];
    return EtherExpression(field, operation, value);
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
