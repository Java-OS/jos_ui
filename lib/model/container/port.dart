class Port {
  final int hostPort;
  final int containerPort;
  final String protocol;
  final String hostIp;
  final int range;

  Port(this.hostPort, this.containerPort, this.protocol, this.hostIp, this.range);

  factory Port.fromMap(Map<String, dynamic> map) {
    var hostPort = map['host_port'];
    var containerPort = map['container_port'];
    var protocol = map['protocol'];
    var hostIp = map['host_ip'];
    var range = map['range'];

    return Port(hostPort, containerPort, protocol, hostIp, range);
  }
}
