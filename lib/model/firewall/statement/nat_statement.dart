import 'package:flutter/material.dart';
import 'package:jos_ui/model/firewall/rule.dart';
import 'package:jos_ui/widget/key_value.dart';

enum NatType {
  snat('SNAT'),
  dnat('DNAT'),
  redirect('REDIRECT'),
  masquerade('MASQUERADE');

  final String value;

  const NatType(this.value);

  factory NatType.fromValue(String value) {
    return NatType.values.firstWhere((item) => item.value == value);
  }
}

enum Flag {
  random('random'),
  persistent('persistent'),
  fullyRandom('fully-random');

  final String value;

  const Flag(this.value);

  factory Flag.fromValue(String value) {
    return Flag.values.firstWhere((item) => item.value == value);
  }
}

class NatStatement implements Statement {
  final List<Flag> flags;
  final NatType type;
  final String? address;
  final int? port;

  NatStatement(this.flags, this.type, this.address, this.port);

  factory NatStatement.fromMap(Map<String, dynamic> map) {
    if (map.containsKey('snat')) {
      var addr = map['snat']['addr'];
      var port = map['snat']['port'];
      var flags = map['snat']['flags'] != null ? (map['snat']['flags'] as List).map((e) => Flag.fromValue(e)).toList() : <Flag>[];
      return NatStatement(flags, NatType.snat, addr, port);
    } else if (map.containsKey('dnat')) {
      var addr = map['dnat']['addr'];
      var port = map['dnat']['port'];
      var flags = map['dnat']['flags'] != null ? (map['dnat']['flags'] as List).map((e) => Flag.fromValue(e)).toList() : <Flag>[];
      return NatStatement(flags, NatType.dnat, addr, port);
    } else if (map.containsKey('redirect')) {
      var port = map['redirect']['port'];
      var flags = map['redirect']['flags'] != null ? (map['redirect']['flags'] as List).map((e) => Flag.fromValue(e)).toList() : <Flag>[];
      return NatStatement(flags, NatType.redirect, null, port);
    } else {
      var flags = map['masquerade']['flags'] != null ? (map['masquerade']['flags'] as List).map((e) => Flag.fromValue(e)).toList() : <Flag>[];
      return NatStatement(flags, NatType.masquerade, null, null);
    }
  }

  @override
  Widget display() {
    if (type == NatType.dnat || type == NatType.snat) {
      return KeyValue(
        k: type.name,
        v: port != null ? '$address : $port' : '$address',
        keyBackgroundColor: Colors.blueGrey,
        valueBackgroundColor: Colors.teal[400]!,
        keyTextColor: Colors.white,
        valueTextColor: Colors.white,
      );
    } else if (type == NatType.redirect) {
      return KeyValue(
        k: type.name,
        v: '$port',
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
          'masquerade',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      );
    }
  }

  @override
  Map<String, dynamic> toMap() {
    if (type == NatType.snat || type == NatType.dnat) {
      return {
        type.name: {
          'addr': address,
          'port': port,
          'flags': flags.map((e) => e.value).toList(),
        }
      };
    } else if (type == NatType.redirect) {
      return {
        'redirect': {
          'port': port,
          'flags': flags.map((e) => e.value).toList(),
        }
      };
    } else {
      return {
        'masquerade': {
          'flags': flags.map((e) => e.value).toList(),
        }
      };
    }
  }
}
