import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/service/api_service.dart';

class EnvironmentController extends GetxController {
  final _apiService = Get.put(ApiService());
  final TextEditingController keyEditingController = TextEditingController();
  final TextEditingController valueEditingController = TextEditingController();
  final TextEditingController batchEditingController = TextEditingController();

  var environments = {}.obs;

  Future<void> fetchSystemEnvironments() async {
    developer.log('Fetch System Environments called');
    _apiService.callApi(Rpc.RPC_SYSTEM_ENVIRONMENT_LIST).then((map) => environments.value = map);
  }

  Future<void> setSystemEnvironment() async {
    developer.log('Add system environments called');
    var key = keyEditingController.text;
    var value = valueEditingController.text;

    _apiService.callApi(Rpc.RPC_SYSTEM_ENVIRONMENT_SET, parameters: {'key': key, 'value': value}, message: 'Failed to add environment [$key]').then((e) => fetchSystemEnvironments()).then((e) => Get.back());
  }

  Future<void> setSystemBatchEnvironment() async {
    developer.log('Add system batch environments called');
    var batch = batchEditingController.text;

    _apiService.callApi(Rpc.RPC_SYSTEM_ENVIRONMENT_BATCH_SET, parameters: {'batch': batch}, message: 'Failed to set batch environments').then((e) => fetchSystemEnvironments()).then((e) => Get.back()).then((e) => clean());
  }

  Future<void> deleteSystemEnvironment(String key) async {
    developer.log('Delete System Environments called');
    _apiService.callApi(Rpc.RPC_SYSTEM_ENVIRONMENT_UNSET, parameters: {'key': key}, message: 'Failed to delete environment $key').then((e) => fetchSystemEnvironments()).then((e) => clean());
  }

  Future<void> updateEnvironment() async {
    var key = keyEditingController.text;
    var value = valueEditingController.text;
    _apiService.callApi(Rpc.RPC_SYSTEM_ENVIRONMENT_UPDATE, parameters: {'key': key, 'value': value}, message: 'Failed to update environment [$key]').then((e) => fetchSystemEnvironments()).then((e) => Get.back()).then((e) => clean());
  }

  void clean() {
    batchEditingController.clear();
    keyEditingController.clear();
    valueEditingController.clear();
  }
}
