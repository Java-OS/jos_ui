import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jos_ui/model/firewall/rule.dart';
import 'package:jos_ui/component/key_value.dart';

enum MetaField {
  l4proto('l4proto'),
  iifname('iifname'),
  oifname('oifname');

  final String value;

  const MetaField(this.value);

  factory MetaField.fromValue(String value) {
    return MetaField.values.firstWhere((item) => item.value == value);
  }
}

class MetaExpression implements Expression {
  final MetaField field;
  final Operation operation;
  final dynamic value;

  MetaExpression(this.field, this.operation, this.value);

  factory MetaExpression.fromMap(Map<String, dynamic> map) {
    var operation = Operation.fromValue(map['match']['op']);
    var field = MetaField.fromValue(map['match']['left']['meta']['key']);
    var value = map['match']['right'];

    return MetaExpression(field, operation, value);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'match': {
        'op': operation.value,
        'left': {
          'meta': {'key': field.value},
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
