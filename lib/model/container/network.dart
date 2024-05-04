import 'package:jos_ui/model/container/subnet.dart';

class Network {
  final String name;
  final bool disableDNS;
  final String driver;
  final String gateway;
  final bool internal;
  final Map<String, String> labels;
  final String macVLAN;
  final Map<String, String> options;
  final List<Subnet> subnets;

  Network(this.name, this.disableDNS, this.driver, this.gateway, this.internal, this.labels, this.macVLAN, this.options, this.subnets);

  factory Network.fromMap(Map<String, dynamic> map) {
    var name = map['Name'];
    var disableDNS = map['DisableDNS'];
    var driver = map['Driver'];
    var gateway = map['Gateway'];
    var internal = map['Internal'];
    var labels = map['Labels'];
    var macVLAN = map['MacVLAN'];
    var options = map['Options'];
    var subnets = map['Subnets'];

    return Network(name, disableDNS, driver, gateway, internal, labels, macVLAN, options, subnets);
  }
}
