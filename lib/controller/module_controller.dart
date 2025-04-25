import 'dart:developer' as developer;

import 'package:get/get.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/model/module.dart';
import 'package:jos_ui/model/module_dependency.dart';

import '../service/api_service.dart';

class ModuleController extends GetxController {
  final _apiService = Get.put(ApiService());
  var moduleList = <Module>[].obs;
  var dependencies = <ModuleDependency>[].obs;
  var selectedDependencies = <ModuleDependency>[].obs;
  var selectedModule = Rxn<Module>();
  var doSelectItems = false.obs;

  Future<void> fetchModules(bool disableLoading) async {
    _apiService.callApi(Rpc.RPC_MODULE_LIST, message: 'Failed to fetch modules',disableLoading: disableLoading).then((e) => e as List).then((e) => moduleList.value = e.map((item) => Module.fromMap(item)).toList());
  }

  Future<void> fetchDependencyLayers() async {
    _apiService.callApi(Rpc.RPC_MODULE_DEP_LAYERS, message: 'Failed to fetch dependency layers').then((e) => e as List).then((e) => dependencies.value = e.map((item) => ModuleDependency.fromMap(item)).toList());
  }

  Future<void> removeModule(String name) async {
    developer.log('try to remove module $name');
    var reqParam = {
      'name': name,
    };
    _apiService.callApi(Rpc.RPC_MODULE_REMOVE, parameters: reqParam).then((e) => fetchModules(false));
  }

  Future<void> startService(String name) async {
    developer.log('try to start module service $name');
    var reqParam = {
      'name': name,
    };
    _apiService.callApi(Rpc.RPC_MODULE_START, parameters: reqParam).then((e) => fetchModules(false));
  }

  Future<void> stopService(String name) async {
    developer.log('try to stop module service $name');
    var reqParam = {
      'name': name,
    };
    _apiService.callApi(Rpc.RPC_MODULE_STOP, parameters: reqParam).then((e) => fetchModules(false));
  }

  Future<void> removeDependencyLayer(String name) async {
    developer.log('try to remove dependency layer $name');
    var reqParam = {
      'name': name,
    };
    _apiService.callApi(Rpc.RPC_MODULE_DEP_LAYER_REMOVE, parameters: reqParam).then((e) => fetchDependencyLayers());
  }

  Future<void> setDependencyLayer() async {
    var name = selectedModule.value!.name;
    var dependencies = selectedDependencies.map((item) => item.name).toList();
    var reqParam = {
      'name': name,
      'dependencies': dependencies,
    };
    _apiService.callApi(Rpc.RPC_MODULE_DEP_SET, parameters: reqParam, disableLoading: true);
  }

  bool isDependencySelected(ModuleDependency dep) {
    return selectedDependencies.any((e) => e.name == dep.name);
  }

  void updateSelectedDependencies(ModuleDependency dep, bool add) {
    if (add) {
      selectedDependencies.add(dep);
    } else {
      selectedDependencies.remove(dep);
    }
    setDependencyLayer().then((_) => fetchModules(true));
  }

  void clear() {
    moduleList = <Module>[].obs;
    dependencies = <ModuleDependency>[].obs;
    selectedDependencies = <ModuleDependency>[].obs;
    selectedModule = Rxn<Module>();
    doSelectItems = false.obs;
  }

  @override
  void onClose() {
    clear();
    super.onClose();
  }
}
