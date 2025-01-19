import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/model/kernel_mod_info.dart';
import 'package:jos_ui/service/api_service.dart';

class KernelController extends GetxController {
  final _apiService = Get.put(ApiService());
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
    _apiService.callApi(Rpc.RPC_SYSTEM_KERNEL_PARAMETER_LIST).then((e) => allKernelParameters.value = Map.from(e));
  }

  Future<void> fetchConfiguredKernelParameters() async {
    developer.log('Fetch configured kernel parameters called');
    _apiService.callApi(Rpc.RPC_SYSTEM_KERNEL_PARAMETER_GET).then((e) => configuredKernelParameters.value = Map.from(e));
  }

  Future<void> setKernelParameter() async {
    developer.log('set kernel parameter called');
    var key = selectedSystemKey.value.trim();
    var value = systemKernelParameterValueEditingController.text.trim();

    var param = {
      'name': key,
      'parameters': value,
    };

    _apiService.callApi(Rpc.RPC_SYSTEM_KERNEL_PARAMETER_SET, parameters: param, message: 'Failed to set kernel parameter $key').then((e) => fetchConfiguredKernelParameters()).then((e) => Get.back()).then((e) => clean());
  }

  Future<void> unsetKernelParameter(String key) async {
    developer.log('Unset kernel parameter called');
    _apiService.callApi(Rpc.RPC_SYSTEM_KERNEL_PARAMETER_UNSET, parameters: {'key': key}, message: 'Failed to unset kernel parameter $key').then((e) => fetchConfiguredKernelParameters()).then((e) => clean());
  }

  Future<void> fetchKernelModules() async {
    developer.log('Fetch kernel modules called');
    _apiService.callApi(Rpc.RPC_SYSTEM_KERNEL_MODULE_LIST).then((e) => e as List).then((e) => moduleList.value = e.map((item) => KernelModInfo.fromMap(item)).toList());
  }

  Future<void> loadKernelModule() async {
    developer.log('Load kernel parameter called');
    var name = systemKernelModuleNameEditingController.text.trim();
    var options = systemKernelModuleOptionsEditingController.text;

    var param = {
      'name': name,
      'options': options,
    };

    _apiService.callApi(Rpc.RPC_SYSTEM_KERNEL_MODULE_LOAD, parameters: param, message: 'Failed to load kernel module $name').then((e) => fetchConfiguredKernelParameters()).then((e) => clean());
  }

  Future<void> unloadKernelModule(String name) async {
    developer.log('Unload kernel module called');
    _apiService.callApi(Rpc.RPC_SYSTEM_KERNEL_MODULE_UNLOAD, parameters: {'name': name}, message: 'Failed to unload kernel module $name').then((e) => fetchConfiguredKernelParameters()).then((e) => clean());
  }

  void clean() {
    selectedSystemKey.value = '';
    systemKernelParameterValueEditingController.clear();
    systemKernelModuleNameEditingController.clear();
    systemKernelModuleOptionsEditingController.clear();
  }
}
