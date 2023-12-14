import 'package:get/get.dart';
import 'package:jos_ui/model/ethernet.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/service/rpc_provider.dart';

class NetworkController extends GetxController {
  var ethernetList = <Ethernet>[].obs;

  Future<void> fetchEthernets() async {
    var response = await RestClient.rpc(RPC.networkEthernetInformation, parameters: {'ethernet': ''});
    if (response.result != null) {
      var result = response.result as List;
      ethernetList.value = result.map((item) => Ethernet.fromJson(item)).toList();
    }
  }
}
