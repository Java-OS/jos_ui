import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/dialog/alert_dialog.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/service/api_service.dart';
import 'package:jos_ui/service/rest_client.dart';
import 'package:jos_ui/widget/toast.dart';

class BackupController extends GetxController {
  final _apiService = Get.put(ApiService());
  final TextEditingController passwordEditingController = TextEditingController();
  var backupList = <String>[].obs;

  Future<void> fetchBackups() async {
    developer.log('Fetch system backups called');
    _apiService
        .callApi(Rpc.RPC_CONFIG_BACKUP_LIST, message: 'Failed to fetch backups')
        .then((payload) => (payload as List).map((e) => e.toString()).toList())
        .then((mappedItems) => backupList.assignAll(mappedItems));
  }

  Future<void> createBackup() async {
    developer.log('Create system backup called');
    _apiService.callApi(Rpc.RPC_CONFIG_BACKUP_CREATE, message: 'Failed to create system backup').then((e) => fetchBackups());
  }

  Future<void> deleteBackup(int index) async {
    developer.log('delete system backup called');
    var reqParam = {'id': index};
    _apiService.callApi(Rpc.RPC_CONFIG_BACKUP_DELETE, parameters: reqParam, message: 'Failed to create system backup').then((e) => fetchBackups());
  }

  Future<void> restoreBackup(int index) async {
    developer.log('Restore system backup called');
    bool accepted = await displayAlertModal('Warning', 'JVM must be restarted for the changes to take effect');
    if (accepted) {
      var reqParam = {'id': index};
      _apiService.callApi(Rpc.RPC_CONFIG_BACKUP_RESTORE, parameters: reqParam).then((e) => fetchBackups());
    }
  }

  Future<void> downloadBackup(int id) async {
    var fileName = backupList[id];
    await RestClient.download('/etc/$fileName', passwordEditingController.text);
    Get.back();
    passwordEditingController.clear();
  }

  Future<void> uploadBackup(Uint8List bytes, String name) async {
    var success = await RestClient.upload(bytes, name, UploadType.UPLOAD_TYPE_CONFIG, passwordEditingController.text);
    if (success) {
      fetchBackups();
      Get.back();
      passwordEditingController.clear();
    } else {
      displayWarning('Failed to upload config file');
    }
  }
}
