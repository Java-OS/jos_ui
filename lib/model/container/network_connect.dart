class NetworkConnect {
  final List<String>? staticIps;
  final String? staticMac;
  final String? interfaceName;

  NetworkConnect(this.staticIps, this.staticMac, this.interfaceName);

  factory NetworkConnect.fromMap(Map<String, dynamic> map) {
    var staticIps = map['static_ips'];
    var staticMac = map['static_mac'];
    var interfaceName = map['interface_name'];

    return NetworkConnect(staticIps, staticMac, interfaceName);
  }

  Map<String, dynamic> toMap() {
    return {
      'static_ips': staticIps,
      'static_mac': staticMac,
      'interface_name': interfaceName,
    };
  }
}
