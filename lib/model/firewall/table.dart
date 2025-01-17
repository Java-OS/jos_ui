enum FirewallTableType {
  ipv4('ip'),
  ipv6('ip6'),
  inet('inet'),
  arp('arp'),
  bridge('bridge'),
  netdev('netdev');

  final String value;

  const FirewallTableType(this.value);

  factory FirewallTableType.fromValue(String value) {
    return FirewallTableType.values.firstWhere((item) => item.value == value);
  }
}

class FirewallTable {
  int? handle;
  String name;
  FirewallTableType type;

  FirewallTable(this.handle, this.name, this.type);

  factory FirewallTable.fromJson(Map<String, dynamic> map) {
    var handle = map['table']['handle'];
    var name = map['table']['name'];
    var type = FirewallTableType.fromValue(map['table']['family']);
    return FirewallTable(handle, name, type);
  }
}
