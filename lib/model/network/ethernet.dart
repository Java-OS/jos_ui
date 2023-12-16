import 'package:jos_ui/model/network/ethernet_statistics.dart';

class Ethernet {
  String? cidr;
  String iface;
  String? ip;
  String? mac;
  String? netmask;
  EthernetStatistic statistic;

  Ethernet({required this.iface, required this.mac, required this.ip, required this.netmask, required this.cidr, required this.statistic});

  factory Ethernet.fromJson(Map<String, dynamic> jsonObject) {
    var ethernetStatistic = EthernetStatistic.fromJson(jsonObject['statistic']);
    var cidr = jsonObject['cidr'] != null ? jsonObject['cidr'].toString() : '';
    return Ethernet(iface: jsonObject['iface'], mac: jsonObject['mac'], ip: jsonObject['ip'], netmask: jsonObject['netmask'], cidr: cidr, statistic: ethernetStatistic);
  }
}