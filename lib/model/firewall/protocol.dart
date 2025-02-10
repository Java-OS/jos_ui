enum Protocol {
  tcp,
  udp,
  icmp;

  factory Protocol.fromValue(String name) {
    return Protocol.values.firstWhere((item) => item.name == name);
  }
}
