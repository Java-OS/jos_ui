import 'package:jos_ui/model/firewall/protocol.dart';

class PortMapping {
  final int containerPort;
  final String? hostIp;
  final int hostPort;
  final Protocol protocol;
  final int? range;

  PortMapping(this.containerPort, this.hostIp, this.hostPort, this.protocol, this.range);

  factory PortMapping.fromMap(Map<String, dynamic> map) {
    var containerPort = map['container_port'];
    var hostIp = map['host_ip'];
    var hostPort = map['host_port'];
    var protocol = map['protocol'];
    var range = map['range'];
    return PortMapping(containerPort, hostIp, hostPort, protocol, range);
  }

  Map<String, dynamic> toMap() {
    return {
      'container_port': containerPort,
      'host_ip': hostIp,
      'host_port': hostPort,
      'protocol': protocol.name.toUpperCase(),
      'range': range,
    };
  }
}
