class Host {
  final int id;
  final String ip;
  final String hostname;

  Host(this.id, this.ip, this.hostname);

  factory Host.fromJson(Map<String, dynamic> map) {
    var id = map['id'];
    var ip = map['ip'];
    var hostname = map['hostname'];

    return Host(id, ip, hostname);
  }
}
