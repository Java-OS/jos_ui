import 'package:flutter/material.dart';
import 'package:jos_ui/model/firewall/rule.dart';
import 'package:jos_ui/widget/key_value.dart';

enum Reason {
  hostUnreachable('host-unreachable'),
  netUnreachable('net-unreachable'),
  protUnreachable('prot-unreachable'),
  portUnreachable('port-unreachable'),
  netProhibited('net-prohibited'),
  hostProhibited('host-prohibited'),
  adminProhibited('admin-prohibited'),
  noRoute('no-route'),
  addrUnreachable('addr-unreachable');

  final String value;

  const Reason(this.value);

  factory Reason.fromValue(String value) {
    return Reason.values.firstWhere((item) => item.value == value);
  }
}

enum Type {
  reject('reject'),
  icmp('icmp'),
  icmpv6('icmpv6'),
  icmpx('icmpx');

  final String value;

  const Type(this.value);

  factory Type.fromValue(String value) {
    return Type.values.firstWhere((item) => item.value == value);
  }
}

class RejectStatement implements Statement {
  final Type type;
  final Reason? reason;

  RejectStatement(this.type, this.reason);

  factory RejectStatement.fromMap(Map<String, dynamic> map) {
    var reason = (map['reject'] as Map).containsKey('reason') ? Reason.fromValue(map['reject']['reason']) : null;
    var type = Type.fromValue(map['reject']['type']);
    return RejectStatement(type, reason);
  }

  @override
  Widget display() {
    if (reason != null) {
      return KeyValue(
        k: 'reject',
        v: reason!.value,
        keyBackgroundColor: Colors.blueGrey,
        valueBackgroundColor: Colors.teal[400]!,
        keyTextColor: Colors.white,
        valueTextColor: Colors.white,
      );
    } else {
      return Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          border: Border.all(width: 0.1, color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Text(
          'reject',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      );
    }
  }
}
