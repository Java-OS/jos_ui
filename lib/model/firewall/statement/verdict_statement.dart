import 'package:flutter/material.dart';
import 'package:jos_ui/model/firewall/rule.dart';

enum VerdictType {
  accept('accept'),
  drop('drop'),
  queue('queue'),
  cont('continue'),
  ret('return'),
  jump('jump'),
  goto('goto');

  final String value;

  const VerdictType(this.value);

  factory VerdictType.fromValue(String value) {
    return VerdictType.values.firstWhere((item) => item.value == value);
  }
}

class VerdictStatement implements Statement {
  final VerdictType type;
  final String? chainName;

  VerdictStatement(this.type, this.chainName);

  factory VerdictStatement.fromMap(Map<String, dynamic> map) {
    var key = map.keys.first;
    switch (key) {
      case 'accept':
        return VerdictStatement(VerdictType.accept, null);
      case 'drop':
        return VerdictStatement(VerdictType.drop, null);
      case 'queue':
        return VerdictStatement(VerdictType.queue, null);
      case 'continue':
        return VerdictStatement(VerdictType.cont, null);
      case 'return':
        return VerdictStatement(VerdictType.ret, null);
      case 'jump':
        return VerdictStatement(VerdictType.jump, map['jump']['target']);
      case 'goto':
        return VerdictStatement(VerdictType.jump, map['goto']['target']);
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

  @override
  Map<String, dynamic> toMap() {
    if (type == VerdictType.jump || type == VerdictType.goto) {
      return {
        type.value: {
          'target': chainName,
        }
      };
    } else {
      return {
        type.value: null,
      };
    }
  }
}
