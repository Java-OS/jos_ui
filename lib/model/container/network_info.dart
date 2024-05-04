import 'package:flutter/material.dart';
import 'package:jos_ui/model/container/subnet.dart';

class NetworkInfo {
  final String name;
  final String id;
  final String driver;
  final String networkInterface;
  final String created;
  final List<Subnet> subnets;
  final bool internal;
  final bool dnsEnabled;
  final Map<String, String> ipamOptions;

  NetworkInfo(this.name, this.id, this.driver, this.networkInterface, this.created, this.subnets, this.internal, this.dnsEnabled, this.ipamOptions);

  factory NetworkInfo.fromMap(Map<String, dynamic> map) {

    var name = map['name'];
    var id = map['id'];
    var driver = map['driver'];
    var networkInterface = map['network_interface'];
    var created = map['created'];
    var subnets = (map['subnets'] as List).map((e) => Subnet.fromMap(e)).toList();
    var internal = map['internal'];
    var dnsEnabled = map['dns_enabled'];
    var ipamOptions = Map<String, String>.from(map['ipam_options']);

    return NetworkInfo(name, id, driver, networkInterface, created, subnets, internal, dnsEnabled, ipamOptions);
  }
}
