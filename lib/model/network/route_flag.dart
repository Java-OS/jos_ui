import 'dart:core';

enum RouteFlag {
  U(1),
  G(2),
  H(4),
  R(8),
  D(16),
  M(32),
  A(64),
  C(128),
  Z(256);

  final int bit;

  const RouteFlag(this.bit);

  int getBit() {
    return bit;
  }

  static RouteFlag getRouteFlag(int bit) {
    return RouteFlag.values.singleWhere((element) => element.getBit() == bit);
  }

  static List<RouteFlag> getAllRouteFlags() {
    return RouteFlag.values;
  }

  static Set<RouteFlag> getRouteFlagsOfBit(int number) {
    return getBitNumbers(number).map((e) => getRouteFlag(e)).toSet();
  }

  static List<int> getBitNumbers(int number) {
    var bitNumbers = <int>[];
    int count = 1;
    while (number != 0) {
      if (number & 1 == 1) bitNumbers.add(count);
      number >>= 1;
      count <<= 1;
    }
    return bitNumbers;
  }

  static int getRouteFlagBit(List<RouteFlag> realms) {
    return realms.map((e) => e.getBit()).reduce((value, element) => value + element);
  }

  static List<RouteFlag> mapToFlags(int bit) {
    var bitNumbers = getBitNumbers(bit);
    return bitNumbers.map((e) => getRouteFlag(e)).toList();
  }

  static String getFlagStr(int bit) {
    String str = '';
    List<RouteFlag> routeFlags = mapToFlags(bit);
    for (var item in routeFlags) {
      str += item.name;
    }
    return str;
  }
}
