import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/model/kernel_mod_info.dart';
import 'package:jos_ui/protobuf/message-buffer.pb.dart';
import 'package:jos_ui/service/rest_client.dart';
import 'package:jos_ui/widget/toast.dart';

class KernelController extends GetxController {
  final TextEditingController systemKernelParameterValueEditingController = TextEditingController();
  final TextEditingController systemKernelModuleNameEditingController = TextEditingController();
  final TextEditingController systemKernelModuleOptionsEditingController = TextEditingController();

  var allKernelParameters = <String, String>{}.obs;
  var configuredKernelParameters = <String, String>{}.obs;
  var selectedSystemKey = ''.obs;
  var moduleList = <KernelModInfo>[].obs;

  Map<String, String> filterSuggestions() {
    Map<String, String> sug = Map.from(allKernelParameters);
    var exists = sug.keys.any((item) => item.contains(RegExp('.*${selectedSystemKey.value}.*', caseSensitive: false)));

    if (exists) {
      sug.removeWhere((k, v) {
        var exists = k.contains(RegExp('.*${selectedSystemKey.value}.*', caseSensitive: false));
        if (exists) return false;
        return true;
      });
      return sug;
    }
    return <String, String>{};
  }

  Future<void> fetchKernelParameters() async {
    developer.log('Fetch all kernel parameters called');
    var payload = await RestClient.rpc(RPC.RPC_SYSTEM_KERNEL_PARAMETER_LIST);
    if (payload.metadata.success) {
      var json = jsonDecode(payload.content) as Map;
      allKernelParameters.value = Map.from(json);
    }
  }

  Future<void> fetchConfiguredKernelParameters() async {
    developer.log('Fetch configured kernel parameters called');
    var payload = await RestClient.rpc(RPC.RPC_SYSTEM_KERNEL_PARAMETER_GET);
    if (payload.metadata.success) {
      var json = jsonDecode(payload.content) as Map;
      configuredKernelParameters.value = Map.from(json);
    }
  }

  Future<void> setKernelParameter() async {
    developer.log('set kernel parameter called');
    var key = selectedSystemKey.value.trim();
    var value = systemKernelParameterValueEditingController.text.trim();

    var param = {
      'name': key,
      'parameters': value,
    };

    var payload = await RestClient.rpc(RPC.RPC_SYSTEM_KERNEL_PARAMETER_SET, parameters: param);
    if (payload.metadata.success) {
      displayInfo('Set kernel parameter $key');
      await fetchConfiguredKernelParameters();
      Get.back();
    } else {
      displayError('Failed to set kernel parameter $key');
    }
    clean();
  }

  Future<void> unsetKernelParameter(String key) async {
    developer.log('Unset kernel parameter called');
    var payload = await RestClient.rpc(RPC.RPC_SYSTEM_KERNEL_PARAMETER_UNSET, parameters: {'key': key});
    if (payload.metadata.success) {
      await fetchConfiguredKernelParameters();
      displayInfo('Environment $key deleted');
    } else {
      displayError('Failed to unset kernel parameter $key');
    }
    clean();
  }

  Future<void> fetchKernelModules() async {
    developer.log('Fetch kernel modules called');
    var payload = await RestClient.rpc(RPC.RPC_SYSTEM_KERNEL_MODULE_LIST);
    if (payload.metadata.success) {
      var json = jsonDecode(payload.content);
      var result = json as List;
      moduleList.value = result.map((item) => KernelModInfo.fromMap(item)).toList();
    }
  }

  Future<void> loadKernelModule() async {
    developer.log('Load kernel parameter called');
    var name = systemKernelModuleNameEditingController.text.trim();
    var options = systemKernelModuleOptionsEditingController.text;

    var param = {
      'name': name,
      'options': options,
    };

    var payload = await RestClient.rpc(RPC.RPC_SYSTEM_KERNEL_MODULE_LOAD, parameters: param);
    if (payload.metadata.success) {
      displayInfo('Module $name loaded');
      await fetchConfiguredKernelParameters();
      Get.back();
    } else {
      displayError('Failed to load kernel module $name');
    }
  }

  Future<void> unloadKernelModule(String name) async {
    developer.log('Unload kernel module called');
    var payload = await RestClient.rpc(RPC.RPC_SYSTEM_KERNEL_MODULE_UNLOAD, parameters: {'name': name});
    if (payload.metadata.success) {
      await fetchKernelModules();
      displayInfo('Module $name unloaded');
      Get.back();
    } else {
      displayError('Failed to unload kernel module $name');
    }
    clean();
  }

  void clean() {
    selectedSystemKey.value = '';
    systemKernelParameterValueEditingController.clear();
    systemKernelModuleNameEditingController.clear();
    systemKernelModuleOptionsEditingController.clear();
  }
}
