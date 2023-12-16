import 'package:jos_ui/model/network/route_flag.dart';

class Route {
  int id;
  String destination;
  String netmask;
  String gateway;
  String iface;
  String flags;
  int metrics;
  int mtu;

  Route(this.id, this.destination, this.netmask, this.gateway, this.iface, this.flags, this.metrics, this.mtu);

  factory Route.fromJson(Map<String, dynamic> jsonObject) {
    var flagBit = jsonObject['flags'];
    return Route(
      jsonObject['id'],
      jsonObject['destination'],
      jsonObject['netmask'],
      jsonObject['gateway'],
      jsonObject['iface'],
      RouteFlag.getFlagStr(flagBit),
      jsonObject['metrics'],
      jsonObject['mtu'],
    );
  }
}
