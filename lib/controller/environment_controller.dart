import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/dialog/toast.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/service/rest_client.dart';

class EnvironmentController extends GetxController {
  final TextEditingController keyEditingController = TextEditingController();
  final TextEditingController valueEditingController = TextEditingController();

  var environments = {}.obs;

  Future<void> fetchSystemEnvironments() async {
    developer.log('Fetch System Environments called');
    var payload = await RestClient.rpc(RPC.systemEnvironmentList);
    if (payload.metadata.success) {
      var json = jsonDecode(payload.postJson) as Map;
      environments.value = Map.from(json); //TODO , check me ...
    }
  }

  Future<void> setSystemEnvironment() async {
    developer.log('Add System Environments called');
    var key = keyEditingController.text;
    var value = valueEditingController.text;

    var payload = await RestClient.rpc(RPC.systemEnvironmentSet, parameters: {'key': key, 'value': value});
    if (payload.metadata.success) {
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
    var payload = await RestClient.rpc(RPC.systemEnvironmentUnset, parameters: {'key': key});
    if (payload.metadata.success) {
      await fetchSystemEnvironments();
      displayInfo('Environment $key deleted');
    } else {
      displayError('Failed to delete environment $key');
    }
  }

  Future<void> updateEnvironment() async {
    var key = keyEditingController.text;
    var value = valueEditingController.text;
    var payload = await RestClient.rpc(RPC.systemEnvironmentUpdate, parameters: {'key': key, 'value': value});
    if (payload.metadata.success) {
      keyEditingController.clear();
      valueEditingController.clear();
      await fetchSystemEnvironments();
      displayInfo('Environment updated [$key]');
      Get.back();
    } else {
      displayError('Failed to update environment [$key]');
    }
  }
}
