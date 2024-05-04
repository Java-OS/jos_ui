class Subnet {
  final String subnet;
  final String gateway;

  Subnet(this.subnet, this.gateway);

  factory Subnet.fromMap(Map<String, dynamic> map) {
    var subnet = map['subnet'];
    var gateway = map['gateway'];

    return Subnet(subnet, gateway);
  }

  Map<String, String> toMap() {
    return {
      'subnet': subnet,
      'gateway': gateway,
    };
  }
}
