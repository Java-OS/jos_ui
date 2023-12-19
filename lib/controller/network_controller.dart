import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jos_ui/dialog/toast.dart';
import 'package:jos_ui/model/network/ethernet.dart';
import 'package:jos_ui/model/network/route.dart' as route;
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/service/rpc_provider.dart';

class NetworkController extends GetxController {
  final TextEditingController gatewayEditingController = TextEditingController();
  final TextEditingController addressEditingController = TextEditingController();
  final TextEditingController netmaskEditingController = TextEditingController();
  final TextEditingController networkEditingController = TextEditingController();
  final TextEditingController metricsEditingController = TextEditingController();
  var ethernetList = <Ethernet>[].obs;
  var routeList = <route.Route>[].obs;
  var routeSelectedEthernet = Rxn<Ethernet>();

  Future<void> fetchEthernets() async {
    var response = await RestClient.rpc(RPC.networkEthernetInformation, parameters: {'ethernet': ''});
    if (response.success) {
      var result = response.result as List;
      ethernetList.value = result.map((item) => Ethernet.fromJson(item)).toList();
    } else {
      displayError('Failed to fetch network interfaces');
    }
  }

  Future<void> fetchRoutes() async {
    var response = await RestClient.rpc(RPC.networkRouteList);
    if (response.success) {
      var result = response.result as List;
      routeList.value = result.map((item) => route.Route.fromJson(item)).toList();
    } else {
      displayError('failed to fetch network routes');
    }
  }

  Future<void> addDefaultGateway() async {
    var response = await RestClient.rpc(RPC.networkRouteDefaultGateway, parameters: {'gateway': gatewayEditingController.text});
    if (response.success) {
      displaySuccess('Add default gateway ${gatewayEditingController.text}');
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
      'ethernet': routeSelectedEthernet.value?.iface ?? '' ,
      'metrics': metricsEditingController.text.isNotEmpty ? int.parse(metricsEditingController.text)  : 600,
    };
    var response = await RestClient.rpc(RPC.networkRouteAdd, parameters: reqParam);
    if (response.success) {
      displaySuccess('Add default gateway ${gatewayEditingController.text}');
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
      'ethernet': routeSelectedEthernet.value?.iface ?? '' ,
      'metrics': metricsEditingController.text.isNotEmpty ? int.parse(metricsEditingController.text)  : 600,
    };
    var response = await RestClient.rpc(RPC.networkRouteAdd, parameters: reqParam);
    if (response.success) {
      displaySuccess('Add default gateway ${gatewayEditingController.text}');
      await fetchRoutes();
      Get.back();
      clear();
    }
  }


  Future<void> deleteRoute(int index) async {
    var response = await RestClient.rpc(RPC.networkRouteDelete, parameters: {'index': index});
    if (response.success) {
      displaySuccess('Route index $index deleted');
      await fetchRoutes();
    }
    clear();
  }

  void clear() {
    gatewayEditingController.clear();
    addressEditingController.clear();
    netmaskEditingController.clear();
    networkEditingController.clear();
    metricsEditingController.clear();
    routeSelectedEthernet.value = null;
  }
}
