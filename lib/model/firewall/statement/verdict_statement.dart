import 'package:flutter/material.dart';
import 'package:jos_ui/model/firewall/rule.dart';

enum Type {
  accept('accept'),
  drop('drop'),
  queue('queue'),
  cont('continue'),
  ret('return'),
  jump('jump'),
  goto('goto');

  final String value;

  const Type(this.value);

  factory Type.fromValue(String value) {
    return Type.values.firstWhere((item) => item.value == value);
  }
}

class VerdictStatement implements Statement {
  final Type type;
  final String? chainName;

  VerdictStatement(this.type, this.chainName);

  factory VerdictStatement.fromMap(Map<String, dynamic> map) {
    var key = map.keys.first;
    switch (key) {
      case 'accept':
        return VerdictStatement(Type.accept, null);
      case 'drop':
        return VerdictStatement(Type.drop, null);
      case 'queue':
        return VerdictStatement(Type.queue, null);
      case 'continue':
        return VerdictStatement(Type.cont, null);
      case 'return':
        return VerdictStatement(Type.ret, null);
      case 'jump':
        return VerdictStatement(Type.jump, map['jump']['target']);
      case 'goto':
        return VerdictStatement(Type.jump, map['goto']['target']);
      default:
        throw ArgumentError('Unsupported verdict type: $key');
    }
  }

  @override
  Widget display() {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        border: Border.all(width: 0.1, color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Text(
        type.value,
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
