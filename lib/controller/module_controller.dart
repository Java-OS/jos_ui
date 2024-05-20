import 'dart:convert';
import 'dart:developer' as developer;

import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:get/get.dart';
import 'package:jos_ui/model/module.dart';
import 'package:jos_ui/protobuf/message-buffer.pb.dart';
import 'package:jos_ui/service/rest_client.dart';
import 'package:jos_ui/widget/toast.dart';

class ModuleController extends GetxController {
  var moduleList = <Module>[].obs;

  Future<void> fetchModules() async {
    var payload = await RestClient.rpc(RPC.RPC_MODULE_LIST);
    if (payload.metadata.success) {
      var json = jsonDecode(payload.content);
      var result = json as List;
      moduleList.value = result.map((item) => Module.fromJson(item)).toList();
    } else {
      displayError('Failed to fetch network interfaces');
    }
  }

  Future<void> removeModule(String moduleName, String version) async {
    var fullName = '$moduleName:$version';
    developer.log('try to remove module $fullName');
    var reqParam = {
      'moduleName': fullName,
    };
    var payload = await RestClient.rpc(RPC.RPC_MODULE_REMOVE, parameters: reqParam);
    if (payload.metadata.success) {
      await fetchModules();
    }
  }

  Future<void> enableModule(String moduleName, String version) async {
    var fullName = '$moduleName:$version';
    developer.log('try to enable module $fullName');
    var reqParam = {
      'moduleName': fullName,
    };
    var payload = await RestClient.rpc(RPC.RPC_MODULE_ENABLE, parameters: reqParam);
    if (payload.metadata.success) {
      await fetchModules();
    }
  }

  Future<void> disableModule(String moduleName, String version) async {
    var fullName = '$moduleName:$version';
    developer.log('try to disable module $fullName');
    var reqParam = {
      'moduleName': fullName,
    };
    var payload = await RestClient.rpc(RPC.RPC_MODULE_DISABLE, parameters: reqParam);
    if (payload.metadata.success) {
      await fetchModules();
    }
  }

  Future<void> startService(String moduleName, String version) async {
    var fullName = '$moduleName:$version';
    developer.log('try to start module service $fullName');
    var reqParam = {
      'moduleName': fullName,
    };
    var payload = await RestClient.rpc(RPC.RPC_MODULE_START, parameters: reqParam);
    if (payload.metadata.success) {
      await fetchModules();
    }
  }

  Future<void> stopService(String moduleName, String version) async {
    var fullName = '$moduleName:$version';
    developer.log('try to stop module service $fullName');
    var reqParam = {
      'moduleName': fullName,
    };
    var payload = await RestClient.rpc(RPC.RPC_MODULE_STOP, parameters: reqParam);
    if (payload.metadata.success) {
      await fetchModules();
    }
  }

  Future<void> uploadModule() async {
    var picked = await FilePickerWeb.platform.pickFiles();
    if (picked != null) {
      var uploaded = await RestClient.upload(picked.files.single.bytes!, picked.files.single.name, UploadType.UPLOAD_TYPE_MODULE, null);
      if (uploaded) fetchModules();
    }
  }
}
