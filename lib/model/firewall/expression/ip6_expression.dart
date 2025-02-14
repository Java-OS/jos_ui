import 'package:flutter/material.dart';
import 'package:jos_ui/model/firewall/rule.dart';
import 'package:jos_ui/component/key_value.dart';

enum Ip6Field {
  daddr('daddr'),
  dscp('dscp'),
  flowlabel('flowlabel'),
  hoplimit('hoplimit'),
  length('length'),
  nexthdr('nexthdr'),
  saddr('saddr'),
  version('version');

  final String value;

  const Ip6Field(this.value);

  factory Ip6Field.fromValue(String value) {
    return Ip6Field.values.firstWhere((item) => item.value == value);
  }
}

class Ip6Expression implements Expression {
  final Ip6Field field;
  final Operation operation;
  final String value;

  Ip6Expression(this.field, this.operation, this.value);

  factory Ip6Expression.fromMap(Map<String, dynamic> map) {
    var operation = Operation.fromValue(map['match']['op']);
    var field = Ip6Field.fromValue(map['match']['left']['payload']['field']);
    var value = map['match']['right'];

    return Ip6Expression(field, operation, value);
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
