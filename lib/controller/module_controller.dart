import 'dart:developer' as developer;

import 'package:get/get.dart';
import 'package:jos_ui/dialog/toast.dart';
import 'package:jos_ui/model/module.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/service/rpc_provider.dart';

class ModuleController extends GetxController {
  var moduleList = <Module>[].obs;

  Future<void> fetchModules() async {
    var response = await RestClient.rpc(RPC.moduleList);
    if (response.success) {
      var result = response.result as List;
      moduleList.value = result.map((item) => Module.fromJson(item)).toList();
    } else {
      displayError('Failed to fetch network interfaces');
    }
  }

  Future<void> removeModule(String moduleName,String version) async {
    var fullName = '$moduleName:$version';
    developer.log('try to remove module $fullName');
    var reqParam = {
      'moduleName': fullName,
    };
    var response = await RestClient.rpc(RPC.moduleRemove, parameters: reqParam);
    if (response.success) {
      await fetchModules();
    }
  }

  Future<void> enableModule(String moduleName,String version) async {
    var fullName = '$moduleName:$version';
    developer.log('try to enable module $fullName');
    var reqParam = {
      'moduleName': fullName,
    };
    var response = await RestClient.rpc(RPC.moduleEnable, parameters: reqParam);
    if (response.success) {
      await fetchModules();
    }
  }

  Future<void> disableModule(String moduleName,String version) async {
    var fullName = '$moduleName:$version';
    developer.log('try to disable module $fullName');
    var reqParam = {
      'moduleName': fullName,
    };
    var response = await RestClient.rpc(RPC.moduleDisable, parameters: reqParam);
    if (response.success) {
      await fetchModules();
    }
  }

  Future<void> startService(String moduleName,String version) async {
    var fullName = '$moduleName:$version';
    developer.log('try to start module service $fullName');
    var reqParam = {
      'moduleName': fullName,
    };
    var response = await RestClient.rpc(RPC.moduleStart, parameters: reqParam);
    if (response.success) {
      await fetchModules();
    }
  }

  Future<void> stopService(String moduleName,String version) async {
    var fullName = '$moduleName:$version';
    developer.log('try to stop module service $fullName');
    var reqParam = {
      'moduleName': fullName,
    };
    var response = await RestClient.rpc(RPC.moduleStop, parameters: reqParam);
    if (response.success) {
      await fetchModules();
    }
  }
}
