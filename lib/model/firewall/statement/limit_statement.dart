import 'package:flutter/material.dart';
import 'package:jos_ui/model/firewall/rule.dart';
import 'package:jos_ui/widget/key_value.dart';

enum TimeUnit {
  second('second'),
  minute('minute'),
  hour('hour'),
  day('day');

  final String value;

  const TimeUnit(this.value);

  factory TimeUnit.fromValue(String value) {
    return TimeUnit.values.firstWhere((item) => item.value == value);
  }
}

enum ByteUnit {
  bytes('BYTES'),
  kbytes('KBYTES'),
  mbytes('MBYTES');

  final String value;

  const ByteUnit(this.value);

  factory ByteUnit.fromValue(String value) {
    return ByteUnit.values.firstWhere((item) => item.value == value.toUpperCase());
  }
}

class LimitStatement implements Statement {
  final int? rate;
  final int? burst;
  final bool? isOver;
  final TimeUnit? timeUnit;
  final ByteUnit? rateUnit;
  final ByteUnit? burstUnit;

  LimitStatement(this.rate, this.burst, this.isOver, this.timeUnit, this.rateUnit, this.burstUnit);

  factory LimitStatement.fromMap(Map<String, dynamic> map) {
    var rate = map['limit']['rate'];
    var burst = map['limit']['burst'];
    var per = map['limit']['per'];
    var inv = map['limit']['inv'];
    var rateUnit = map['limit']['rate_unit'];
    var burstUnit = map['limit']['burst_unit'];

    if (rateUnit == null) {
      return LimitStatement(rate, null, inv, TimeUnit.fromValue(per), null, null);
    } else if (burst == null) {
      return LimitStatement(rate, null, null, TimeUnit.fromValue(per), ByteUnit.fromValue(rateUnit), ByteUnit.fromValue(burstUnit));
    } else {
      return LimitStatement(rate, burst, inv, TimeUnit.fromValue(per), ByteUnit.fromValue(rateUnit), ByteUnit.fromValue(burstUnit));
    }
  }

  @override
  Widget display() {
    if (timeUnit == null) {
      return KeyValue(
        k: 'limit',
        v: (isOver != null && isOver!) ? 'rate over $rate/${timeUnit!.value}' : 'rate $rate/${timeUnit!.value}',
        keyBackgroundColor: Colors.blueGrey,
        valueBackgroundColor: Colors.teal[400]!,
        keyTextColor: Colors.white,
        valueTextColor: Colors.white,
      );
    } else if (burst == null) {
      return KeyValue(
        k: 'limit',
        v: (isOver != null && isOver!) ? 'rate over $rate ${rateUnit!.name}/${timeUnit!.value}' : 'rate $rate ${rateUnit!.name}/${timeUnit!.value}',
        keyBackgroundColor: Colors.blueGrey,
        valueBackgroundColor: Colors.teal[400]!,
        keyTextColor: Colors.white,
        valueTextColor: Colors.white,
      );
    } else {
      return KeyValue(
        k: 'limit',
        v: 'rate : $rate/${timeUnit!.value}  -  burst : $burst ${burstUnit!.name}',
        keyBackgroundColor: Colors.blueGrey,
        valueBackgroundColor: Colors.teal[400]!,
        keyTextColor: Colors.white,
        valueTextColor: Colors.white,
      );
    }
  }
}
