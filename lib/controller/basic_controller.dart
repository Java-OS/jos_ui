import 'dart:developer' as developer;

import 'package:get/get.dart';
import 'package:jos_ui/dialog/alert_dialog.dart';
import 'package:jos_ui/dialog/toast.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/service/rpc_provider.dart';

class BasicController extends GetxController {
  var hostname = ''.obs;

  Future<void> fetchHostname() async {
    developer.log('Fetch hostname called');
    var response = await RestClient.rpc(RPC.systemGetHostname);
    if (response.result != null) {
      hostname.value = response.result;
    } else {
      displayError('Failed to fetch hostname');
    }
  }

  Future<void> changeHostname() async {
    developer.log('Change hostname called');
    bool accepted = await displayAlertModal('Warning', 'JVM immediately must be reset after change hostname.');
    if (accepted) {
      var rpcResponse = await RestClient.rpc(RPC.systemSetHostname, parameters: {'hostname': hostname.value});
      if (rpcResponse.success) {
        displaySuccess('Hostname changed');
      } else {
        displayWarning('Failed to change hostname');
      }
    }
  }
}
