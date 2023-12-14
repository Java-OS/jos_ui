import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/dialog/toast.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/service/rpc_provider.dart';

class EnvironmentController extends GetxController {
  final TextEditingController keyEditingController = TextEditingController();
  final TextEditingController valueEditingController = TextEditingController();

  var environments = {}.obs;

  Future<void> fetchSystemEnvironments() async {
    developer.log('Fetch System Environments called');
    var response = await RestClient.rpc(RPC.systemEnvironmentList);
    if (response.result != null) {
      environments.value = Map.from(response.result);
    }
  }

  Future<void> setSystemEnvironment() async {
    developer.log('Add System Environments called');
    var key = keyEditingController.text;
    var value = valueEditingController.text;

    var response = await RestClient.rpc(RPC.systemEnvironmentSet, parameters: {'key': key, 'value': value});
    if (response.success) {
      keyEditingController.clear();
      valueEditingController.clear();
      await fetchSystemEnvironments();
      displayInfo('Add environment [$key]');
      Get.back();
    } else {
      displayError('Failed to add environment [$key]');
    }
  }

  Future<void> deleteSystemEnvironment(String key) async {
    developer.log('Delete System Environments called');
    var response = await RestClient.rpc(RPC.systemEnvironmentUnset, parameters: {'key': key});
    if (response.success) {
      await fetchSystemEnvironments();
      displayInfo('Environment $key deleted');
    } else {
      displayError('Failed to delete environment $key');
    }
  }
}
