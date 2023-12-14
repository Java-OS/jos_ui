import 'dart:developer' as developer;

import 'package:get/get.dart';
import 'package:jos_ui/dialog/toast.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/service/rpc_provider.dart';

class EnvironmentController extends GetxController {
  var environments = {}.obs;

  Future<void> fetchSystemEnvironments() async {
    developer.log('Fetch System Environments called');
    var response = await RestClient.rpc(RPC.systemEnvironmentList);
    if (response.result != null) {
      environments.value = Map.from(response.result);
    }
  }

  Future<void> deleteSystemEnvironment(String key) async {
    developer.log('Delete System Environments called');
    await RestClient.rpc(RPC.systemEnvironmentUnset, parameters: {'key': key}).then((value) => fetchSystemEnvironments());
    displayInfo('delete environment %s');
  }
}
