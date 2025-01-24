import 'package:flutter/material.dart';
import 'package:jos_ui/model/firewall/chain.dart';
import 'package:jos_ui/model/firewall/expression/ether_expression.dart';
import 'package:jos_ui/model/firewall/expression/ip6_expression.dart';
import 'package:jos_ui/model/firewall/expression/ip_expression.dart';
import 'package:jos_ui/model/firewall/expression/meta_expression.dart';
import 'package:jos_ui/model/firewall/expression/tcp_expression.dart';
import 'package:jos_ui/model/firewall/expression/udp_expression.dart';
import 'package:jos_ui/model/firewall/expression/vlan_expression.dart';
import 'package:jos_ui/model/firewall/statement/counter_statement.dart';
import 'package:jos_ui/model/firewall/statement/limit_statement.dart';
import 'package:jos_ui/model/firewall/statement/log_statement.dart';
import 'package:jos_ui/model/firewall/statement/nat_statement.dart';
import 'package:jos_ui/model/firewall/statement/reject_statement.dart';
import 'package:jos_ui/model/firewall/statement/verdict_statement.dart';

enum Operation {
  eq('=='),
  ne('!='),
  lt('<'),
  gt('>'),
  le('<='),
  ge('>=');

  final String value;

  const Operation(this.value);

  factory Operation.fromValue(String value) {
    return Operation.values.firstWhere((item) => item.value == value);
  }
}

enum MatchType {
  ip('ip'),
  ip6('ip6'),
  tcp('tcp'),
  udp('udp'),
  ether('ether'),
  meta('meta'),
  vlan('vlan');

  final String value;

  const MatchType(this.value);

  factory MatchType.fromValue(String value) {
    return MatchType.values.firstWhere((item) => item.value == value);
  }
}

abstract class Expression {
  Widget display();
}

abstract class Statement {
  Widget display();
}

class FirewallRule {
  final FirewallChain chain;
  final int? handle;
  final String? comment;
  final List<Expression> expressions;
  final List<Statement> statements;

  FirewallRule(this.chain, this.handle, this.comment, this.expressions, this.statements);

  factory FirewallRule.fromMap(Map<String, dynamic> map, FirewallChain firewallChain) {
    var handle = map['rule']['handle'];
    var comment = map['rule']['comment'];
    var exprList = map['rule']['expr'] as List;
    var expressionList = <Expression>[];
    var statementList = <Statement>[];
    for (var i = 0; i < exprList.length; i++) {
      if ((exprList[i] as Map).containsKey('match')) {
        expressionList.add(_extractExpression(exprList[i]));
      } else {
        statementList.add(_extractStatement(exprList[i]));
      }
    }
    return FirewallRule(firewallChain, handle, comment, expressionList, statementList);
  }

  static Expression _extractExpression(Map<String, dynamic> expr) {
    late MatchType matchType = MatchType.meta;
    if ((expr['match']['left'] as Map<String, dynamic>).containsKey('payload')) {
      matchType = MatchType.fromValue(expr['match']['left']['payload']['protocol']);
    }
    switch (matchType) {
      case MatchType.ip:
        return IpExpression.fromMap(expr);
      case MatchType.ip6:
        return Ip6Expression.fromMap(expr);
      case MatchType.tcp:
        return TcpExpression.fromMap(expr);
      case MatchType.udp:
        return UdpExpression.fromMap(expr);
      case MatchType.ether:
        return EtherExpression.fromMap(expr);
      case MatchType.vlan:
        return VlanExpression.fromMap(expr);
      case MatchType.meta:
        return MetaExpression.fromMap(expr);
    }
  }

  static Statement _extractStatement(Map<String, dynamic> stt) {
    if (stt.containsKey('log')) {
      return LogStatement.fromMap(stt);
    } else if (stt.containsKey('counter')) {
      return CounterStatement.fromMap(stt);
    } else if (stt.containsKey('reject')) {
      return RejectStatement.fromMap(stt);
    } else if (stt.containsKey('limit')) {
      return LimitStatement.fromMap(stt);
    } else if (stt.containsKey('snat') || stt.containsKey('dnat') || stt.containsKey('redirect') || stt.containsKey('masquerade')) {
      return NatStatement.fromMap(stt);
    } else {
      return VerdictStatement.fromMap(stt);
    }
  }

  List<Widget> expressionWidgets() {
    var list = <Widget>[];
    for (var item in expressions) {
      list.add(item.display());
    }
    for (var item in statements) {
      list.add(item.display());
    }
    return list;
  }

  List<Widget> statementWidgets() {
    var list = <Widget>[];
    for (var item in statements) {
      list.add(item.display());
    }
    return list;
  }
}
