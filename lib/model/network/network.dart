class Network {
  final int id;
  final String network;
  final int cidr;
  final String name;

  Network(this.id, this.network, this.cidr, this.name);

  factory Network.fromJson(Map<String, dynamic> map) {
    var id = map['id'];
    var network = map['network'];
    var cidr = map['cidr'];
    var name = map['name'];

    return Network(id, network, cidr, name);
  }
}
