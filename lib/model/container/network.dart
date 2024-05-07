import 'package:jos_ui/model/container/subnet.dart';

class Network {
  final String name;
  final List<Subnet> subnets;

  Network(this.name, this.subnets);

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'subnets': [subnets[0].toMap()]
    };
  }
}
