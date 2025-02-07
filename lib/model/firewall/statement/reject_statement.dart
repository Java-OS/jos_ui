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
  addrUnreachable('addr-unreachable'),
  tcpReset('tcp-reset');

  final String value;

  const Reason(this.value);

  factory Reason.fromValue(String value) {
    return Reason.values.firstWhere((item) => item.value == value);
  }
}

class RejectStatement implements Statement {
  final Reason? reason;

  RejectStatement(this.reason);

  factory RejectStatement.fromMap(Map<String, dynamic> map) {
    if ((map['reject'] as Map).containsValue('type') && (map['reject']['type'] as Map).containsValue('tcp-reset')) {
      return RejectStatement(Reason.tcpReset);
    } else {
      var reason = (map['reject'] as Map).containsKey('expr') ? Reason.fromValue(map['reject']['expr']) : null;
      return RejectStatement(reason);
    }
  }

  @override
  Widget display() {
    return KeyValue(
      k: 'reason',
      v: reason!.value,
      keyBackgroundColor: Colors.blueGrey,
      valueBackgroundColor: Colors.teal[400]!,
      keyTextColor: Colors.white,
      valueTextColor: Colors.white,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    if (reason! == Reason.tcpReset) {
      return {
        'reject': {
          'type': reason!.value,
        }
      };
    }
    return {
      'reject': {
        'type': 'icmp',
        'expr': reason!.value,
      }
    };
  }
}
