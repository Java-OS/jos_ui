import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/model/network/ethernet.dart';
import 'package:jos_ui/model/network/route.dart' as route;
import 'package:jos_ui/service/api_service.dart';

class NetworkController extends GetxController {
  final _apiService = Get.put(ApiService());
  final TextEditingController gatewayEditingController = TextEditingController();
  final TextEditingController addressEditingController = TextEditingController();
  final TextEditingController netmaskEditingController = TextEditingController();
  final TextEditingController networkEditingController = TextEditingController();
  final TextEditingController metricsEditingController = TextEditingController();
  final TextEditingController hostIpEditingController = TextEditingController();
  final TextEditingController hostHostnameEditingController = TextEditingController();

  final TextEditingController networkNetworkEditingController = TextEditingController();
  final TextEditingController networkCidrEditingController = TextEditingController();
  final TextEditingController networkNameEditingController = TextEditingController();

  var ethernetList = <Ethernet>[].obs;
  var routeList = <route.Route>[].obs;
  var routeSelectedEthernet = Rxn<Ethernet>();
  var hosts = <String, String>{}.obs;
  var networks = <String, String>{}.obs;

  Future<void> fetchEthernets() async {
    _apiService.callApi(Rpc.RPC_NETWORK_ETHERNET_INFORMATION, parameters: {'ethernet': ''}, message: 'Failed to fetch network interfaces').then((e) => e as List).then((e) => ethernetList.value = e.map((item) => Ethernet.fromJson(item)).toList());
  }

  Future<void> fetchRoutes() async {
    _apiService.callApi(Rpc.RPC_NETWORK_ROUTE_LIST, message: 'failed to fetch network routes').then((e) => e as List).then((e) => routeList.value = e.map((item) => route.Route.fromJson(item)).toList());
  }

  Future<void> addDefaultGateway() async {
    _apiService.callApi(Rpc.RPC_NETWORK_ROUTE_DEFAULT_GATEWAY, parameters: {'gateway': gatewayEditingController.text}).then((e) => fetchRoutes()).then((e) => Get.back()).then((e) => clean());
  }

  Future<void> addHostRoute() async {
    var reqParam = {
      'host': addressEditingController.text,
      'netmask': '255.255.255.255',
      'gateway': gatewayEditingController.text,
      'ethernet': routeSelectedEthernet.value?.iface ?? '',
      'metrics': metricsEditingController.text.isNotEmpty ? int.parse(metricsEditingController.text) : 600,
    };
    _apiService.callApi(Rpc.RPC_NETWORK_ROUTE_ADD, parameters: reqParam).then((e) => fetchRoutes()).then((e) => Get.back()).then((e) => clean());
  }

  Future<void> addNetworkRoute() async {
    var reqParam = {
      'network': networkEditingController.text,
      'netmask': netmaskEditingController.text,
      'gateway': gatewayEditingController.text,
      'ethernet': routeSelectedEthernet.value?.iface ?? '',
      'metrics': metricsEditingController.text.isNotEmpty ? int.parse(metricsEditingController.text) : 600,
    };
    _apiService.callApi(Rpc.RPC_NETWORK_ROUTE_ADD, parameters: reqParam).then((e) => fetchRoutes()).then((e) => Get.back()).then((e) => clean());
  }

  Future<void> deleteRoute(int index) async {
    _apiService.callApi(Rpc.RPC_NETWORK_ROUTE_DELETE, parameters: {'index': index}).then((e) => fetchRoutes()).then((e) => clean());
  }

  Future<void> setIp(String iface) async {
    var reqParam = {
      'ethernet': iface,
      'ipAddress': addressEditingController.text,
      'netmask': netmaskEditingController.text,
    };

    _apiService.callApi(Rpc.RPC_NETWORK_ETHERNET_SET_IP, parameters: reqParam).then((e) => fetchEthernets()).then((e) => Get.back()).then((e) => clean());
  }

  Future<void> ifDown(String iface) async {
    var reqParam = {'ethernet': iface};
    _apiService.callApi(Rpc.RPC_NETWORK_ETHERNET_DOWN, parameters: reqParam).then((e) => fetchEthernets()).then((e) => clean());
  }

  Future<void> ifUp(String iface) async {
    var reqParam = {'ethernet': iface};
    _apiService.callApi(Rpc.RPC_NETWORK_ETHERNET_UP, parameters: reqParam).then((e) => fetchEthernets()).then((e) => clean());
  }

  Future<void> flush(String iface) async {
    var reqParam = {'ethernet': iface};
    _apiService.callApi(Rpc.RPC_NETWORK_ETHERNET_FLUSH, parameters: reqParam).then((e) => fetchEthernets()).then((e) => clean());
  }

  Future<void> fetchHosts() async {
    developer.log('fetch hosts');
    _apiService.callApi(Rpc.RPC_NETWORK_HOSTS_LIST, message: 'Failed to fetch hosts').then((e) => hosts.value = Map.from(e));
  }

  void addHost() async {
    var ip = hostIpEditingController.text;
    var hostname = hostHostnameEditingController.text;
    developer.log('Add new host: $ip $hostname');
    var reqParam = {
      'ip': ip,
      'hostname': hostname,
    };
    _apiService.callApi(Rpc.RPC_NETWORK_HOSTS_ADD, parameters: reqParam, message: 'Failed to add host').then((e) => fetchHosts()).then((e) => Get.back()).then((e) => clean());
  }

  void removeHost(String hostname) async {
    developer.log('Remove host: $hostname');
    var reqParam = {
      'hostname': hostname,
    };
    _apiService.callApi(Rpc.RPC_NETWORK_HOSTS_DELETE, parameters: reqParam, message: 'Failed to remove host').then((e) => fetchHosts());
  }

  Future<void> fetchNetworks() async {
    developer.log('fetch networks');
    _apiService.callApi(Rpc.RPC_NETWORK_NETWORK_LIST, message: 'Failed to fetch networks').then((e) => networks.value = Map.from(e));
  }

  void addNetwork() async {
    var network = networkNetworkEditingController.text;
    var name = networkNameEditingController.text;
    developer.log('Add new network: $network $name');
    var reqParam = {
      'network': network,
      'name': name,
    };
    _apiService.callApi(Rpc.RPC_NETWORK_NETWORK_ADD, parameters: reqParam, message: 'Failed to add network').then((e) => fetchNetworks()).then((e) => Get.back()).then((e) => clean());
  }

  void removeNetwork(String name) async {
    developer.log('Remove network: $name');
    var reqParam = {
      'name': name,
    };
    _apiService.callApi(Rpc.RPC_NETWORK_NETWORK_DELETE, parameters: reqParam, message: 'Failed to remove network').then((e) => fetchNetworks());
  }

  void clean() {
    gatewayEditingController.clear();
    addressEditingController.clear();
    netmaskEditingController.clear();
    networkEditingController.clear();
    metricsEditingController.clear();
    hostIpEditingController.clear();
    hostHostnameEditingController.clear();
    networkNetworkEditingController.clear();
    networkCidrEditingController.clear();
    networkNameEditingController.clear();
    routeSelectedEthernet.value = null;
  }
}
