import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jos_ui/model/network/ethernet.dart';
import 'package:jos_ui/model/network/route.dart' as route;
import 'package:jos_ui/protobuf/message-buffer.pb.dart';
import 'package:jos_ui/service/rest_client.dart';
import 'package:jos_ui/widget/toast.dart';

class NetworkController extends GetxController {
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
    var payload = await RestClient.rpc(RPC.RPC_NETWORK_ETHERNET_INFORMATION, parameters: {'ethernet': ''});
    if (payload.metadata.success) {
      var result = jsonDecode(payload.content) as List;
      ethernetList.value = result.map((item) => Ethernet.fromJson(item)).toList();
    } else {
      displayError('Failed to fetch network interfaces');
    }
  }

  Future<void> fetchRoutes() async {
    var payload = await RestClient.rpc(RPC.RPC_NETWORK_ROUTE_LIST);
    if (payload.metadata.success) {
      var json = jsonDecode(payload.content);
      var result = json as List;
      routeList.value = result.map((item) => route.Route.fromJson(item)).toList();
    } else {
      displayError('failed to fetch network routes');
    }
  }

  Future<void> addDefaultGateway() async {
    var payload = await RestClient.rpc(RPC.RPC_NETWORK_ROUTE_DEFAULT_GATEWAY, parameters: {'gateway': gatewayEditingController.text});
    if (payload.metadata.success) {
      await fetchRoutes();
      Get.back();
    }
    clear();
  }

  Future<void> addHostRoute() async {
    var reqParam = {
      'host': addressEditingController.text,
      'netmask': '255.255.255.255',
      'gateway': gatewayEditingController.text,
      'ethernet': routeSelectedEthernet.value?.iface ?? '',
      'metrics': metricsEditingController.text.isNotEmpty ? int.parse(metricsEditingController.text) : 600,
    };
    var payload = await RestClient.rpc(RPC.RPC_NETWORK_ROUTE_ADD, parameters: reqParam);
    if (payload.metadata.success) {
      await fetchRoutes();
      Get.back();
      clear();
    }
  }

  Future<void> addNetworkRoute() async {
    var reqParam = {
      'network': networkEditingController.text,
      'netmask': netmaskEditingController.text,
      'gateway': gatewayEditingController.text,
      'ethernet': routeSelectedEthernet.value?.iface ?? '',
      'metrics': metricsEditingController.text.isNotEmpty ? int.parse(metricsEditingController.text) : 600,
    };
    var payload = await RestClient.rpc(RPC.RPC_NETWORK_ROUTE_ADD, parameters: reqParam);
    if (payload.metadata.success) {
      await fetchRoutes();
      Get.back();
      clear();
    }
  }

  Future<void> deleteRoute(int index) async {
    var payload = await RestClient.rpc(RPC.RPC_NETWORK_ROUTE_DELETE, parameters: {'index': index});
    if (payload.metadata.success) {
      await fetchRoutes();
    }
    clear();
  }

  Future<void> setIp(String iface) async {
    var reqParam = {
      'ethernet': iface,
      'ipAddress': addressEditingController.text,
      'netmask': netmaskEditingController.text,
    };

    var payload = await RestClient.rpc(RPC.RPC_NETWORK_ETHERNET_SET_IP, parameters: reqParam);
    if (payload.metadata.success) {
      await fetchEthernets();
      Get.back();
      clear();
    }
  }

  Future<void> ifDown(String iface) async {
    var reqParam = {'ethernet': iface};
    var payload = await RestClient.rpc(RPC.RPC_NETWORK_ETHERNET_DOWN, parameters: reqParam);
    if (payload.metadata.success) {
      await fetchEthernets();
      clear();
    }
  }

  Future<void> ifUp(String iface) async {
    var reqParam = {'ethernet': iface};
    var payload = await RestClient.rpc(RPC.RPC_NETWORK_ETHERNET_UP, parameters: reqParam);
    if (payload.metadata.success) {
      await fetchEthernets();
      clear();
    }
  }

  Future<void> flush(String iface) async {
    var reqParam = {'ethernet': iface};
    var payload = await RestClient.rpc(RPC.RPC_NETWORK_ETHERNET_FLUSH, parameters: reqParam);
    if (payload.metadata.success) {
      await fetchEthernets();
      clear();
    }
  }

  Future<void> fetchHosts() async {
    developer.log('fetch hosts');
    var payload = await RestClient.rpc(RPC.RPC_NETWORK_HOSTS_LIST);
    if (payload.metadata.success) {
      var map = jsonDecode(payload.content) as Map;
      hosts.value = Map.from(map);
    } else {
      displayWarning('Failed to fetch hosts');
    }
  }

  void addHost() async {
    var ip = hostIpEditingController.text;
    var hostname = hostHostnameEditingController.text;
    developer.log('Add new host: $ip $hostname');
    var reqParam = {
      'ip': ip,
      'hostname': hostname,
    };
    var payload = await RestClient.rpc(RPC.RPC_NETWORK_HOSTS_ADD, parameters: reqParam);
    if (payload.metadata.success) {
      await fetchHosts();
      clear();
      Get.back();
    } else {
      displayWarning('Failed to add host');
    }
  }

  void removeHost(String hostname) async {
    developer.log('Remove host: $hostname');
    var reqParam = {
      'hostname': hostname,
    };
    var payload = await RestClient.rpc(RPC.RPC_NETWORK_HOSTS_DELETE, parameters: reqParam);
    if (payload.metadata.success) {
      await fetchHosts();
    } else {
      displayWarning('Failed to remove host');
    }
  }

  Future<void> fetchNetworks() async {
    developer.log('fetch networks');
    var payload = await RestClient.rpc(RPC.RPC_NETWORK_NETWORK_LIST);
    if (payload.metadata.success) {
      var map = jsonDecode(payload.content) as Map;
      networks.value = Map.from(map);
    } else {
      displayWarning('Failed to fetch networks');
    }
  }

  void addNetwork() async {
    var network = networkNetworkEditingController.text;
    var name = networkNameEditingController.text;
    developer.log('Add new network: $network $name');
    var reqParam = {
      'network': network,
      'name': name,
    };
    var payload = await RestClient.rpc(RPC.RPC_NETWORK_NETWORK_ADD, parameters: reqParam);
    if (payload.metadata.success) {
      await fetchNetworks();
      clear();
      Get.back();
    } else {
      displayWarning('Failed to add network');
    }
  }

  void removeNetwork(String name) async {
    developer.log('Remove network: $name');
    var reqParam = {
      'name': name,
    };
    var payload = await RestClient.rpc(RPC.RPC_NETWORK_NETWORK_DELETE, parameters: reqParam);
    if (payload.metadata.success) {
      await fetchNetworks();
    } else {
      displayWarning('Failed to remove network');
    }
  }

  void clear() {
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
