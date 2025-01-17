import 'package:jos_ui/model/firewall/table.dart';

enum ChainHook {
  ingress('ingress'),
  egress('egress'),
  prerouting('prerouting'),
  forward('forward'),
  postrouting('postrouting'),
  input('input'),
  output('output');

  final String value;

  const ChainHook(this.value);

  factory ChainHook.fromValue(String value) {
    return ChainHook.values.firstWhere((item) => item.value == value);
  }

  static List<ChainHook> getHooks(ChainType type) {
    if (type == ChainType.filter) {
      return [ChainHook.prerouting, ChainHook.input, ChainHook.forward, ChainHook.output, ChainHook.postrouting];
    } else if (type == ChainType.nat) {
      return [ChainHook.prerouting, ChainHook.input, ChainHook.output, ChainHook.postrouting];
    } else {
      return [ChainHook.output];
    }
  }
}

enum ChainType {
  filter('filter'),
  route('route'),
  nat('nat');

  final String value;

  const ChainType(this.value);

  factory ChainType.fromValue(String value) {
    return ChainType.values.firstWhere((item) => item.value == value);
  }

  static List<ChainType> getChainTypes(FirewallTableType tableType) {
    if (tableType == FirewallTableType.inet || tableType == FirewallTableType.ipv4 || tableType == FirewallTableType.ipv6) {
      return [ChainType.filter, ChainType.nat, ChainType.route];
    } else {
      return [ChainType.filter];
    }
  }
}

enum ChainPolicy {
  accept('accept'),
  drop('drop');

  final String value;

  const ChainPolicy(this.value);

  factory ChainPolicy.fromValue(String value) {
    return ChainPolicy.values.firstWhere((item) => item.value == value);
  }
}

class FirewallChain {
  FirewallTable table;
  String name;
  int? handle;
  int? priority;
  ChainType? type;
  ChainHook? hook;
  ChainPolicy? policy;

  FirewallChain(this.table, this.name, this.handle, this.type, this.hook, this.priority, this.policy);

  factory FirewallChain.fromJson(Map<String, dynamic> map, int tableHandle) {
    var tableName = map['chain']['table'];
    var tableType = map['chain']['family'];
    var table = FirewallTable(tableHandle, tableName, FirewallTableType.fromValue(tableType));
    var name = map['chain']['name'];
    var handle = map['chain']['handle'];
    var priority = map['chain']['prio'];
    var type = map['chain']['type'] != null ? ChainType.fromValue(map['chain']['type']) : null;
    var hook = map['chain']['hook'] != null ? ChainHook.fromValue(map['chain']['hook']) : null;
    var policy = map['chain']['policy'] != null ? ChainPolicy.fromValue(map['chain']['policy']) : null;

    return FirewallChain(table, name, handle, type, hook, priority, policy);
  }
}
