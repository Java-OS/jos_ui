import 'dart:developer' as developer;

import 'package:get/get.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/model/module.dart';

import '../service/api_service.dart';

class ModuleController extends GetxController {
  final _apiService = Get.put(ApiService());
  var moduleList = <Module>[].obs;

  Future<void> fetchModules() async {
    _apiService.callApi(Rpc.RPC_MODULE_LIST, message: 'Failed to fetch modules').then((e) => e as List).then((e) => moduleList.value = e.map((item) => Module.fromMap(item)).toList());
  }

  Future<void> removeModule(String moduleName, String version) async {
    var fullName = '$moduleName:$version';
    developer.log('try to remove module $fullName');
    var reqParam = {
      'moduleName': fullName,
    };
    _apiService.callApi(Rpc.RPC_MODULE_REMOVE, parameters: reqParam).then((e) => fetchModules());
  }

  Future<void> enableModule(String moduleName, String version) async {
    var fullName = '$moduleName:$version';
    developer.log('try to enable module $fullName');
    var reqParam = {
      'moduleName': fullName,
    };
    _apiService.callApi(Rpc.RPC_MODULE_ENABLE, parameters: reqParam).then((e) => fetchModules());
  }

  Future<void> disableModule(String moduleName, String version) async {
    var fullName = '$moduleName:$version';
    developer.log('try to disable module $fullName');
    var reqParam = {
      'moduleName': fullName,
    };
    _apiService.callApi(Rpc.RPC_MODULE_DISABLE, parameters: reqParam).then((e) => fetchModules());
  }

  Future<void> startService(String moduleName, String version) async {
    var fullName = '$moduleName:$version';
    developer.log('try to start module service $fullName');
    var reqParam = {
      'moduleName': fullName,
    };
    _apiService.callApi(Rpc.RPC_MODULE_START, parameters: reqParam).then((e) => fetchModules());
  }

  Future<void> stopService(String moduleName, String version) async {
    var fullName = '$moduleName:$version';
    developer.log('try to stop module service $fullName');
    var reqParam = {
      'moduleName': fullName,
    };
    _apiService.callApi(Rpc.RPC_MODULE_STOP, parameters: reqParam).then((e) => fetchModules());
  }
}
