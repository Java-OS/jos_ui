import 'package:get/get.dart';
import 'package:jos_ui/dialog/toast.dart';
import 'package:jos_ui/model/network/ethernet.dart';
import 'package:jos_ui/model/network/route.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/service/rpc_provider.dart';

class NetworkController extends GetxController {
  var ethernetList = <Ethernet>[].obs;
  var routeList = <Route>[].obs;

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
      routeList.value = result.map((item) => Route.fromJson(item)).toList();
    } else {
      displayError('failed to fetch network routes');
    }
  }
}
