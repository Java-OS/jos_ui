import 'package:flutter/material.dart';
import 'package:jos_ui/model/firewall/rule.dart';
import 'package:jos_ui/component/key_value.dart';

enum VlanField {
  cfi('cfi'),
  id('id'),
  pcp('pcp');

  final String value;

  const VlanField(this.value);

  factory VlanField.fromValue(String value) {
    return VlanField.values.firstWhere((item) => item.value == value);
  }
}

class VlanExpression implements Expression {
  final VlanField field;
  final Operation operation;
  final dynamic value;

  VlanExpression(this.field, this.operation, this.value);

  factory VlanExpression.fromMap(Map<String, dynamic> map) {
    var operation = Operation.fromValue(map['match']['op']);
    var field = VlanField.fromValue(map['match']['left']['payload']['field']);
    var value = map['match']['right'];
    return VlanExpression(field, operation, value);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'match': {
        'op': operation.value,
        'left': {
          'payload': {'protocol': 'vlan', 'field': field.value},
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
