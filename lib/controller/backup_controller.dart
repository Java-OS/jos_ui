import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/dialog/alert_dialog.dart';
import 'package:jos_ui/dialog/toast.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/service/rest_client.dart';

class BackupController extends GetxController {
  final TextEditingController passwordEditingController = TextEditingController();
  var backupList = <String>[].obs;

  Future<void> fetchBackups() async {
    developer.log('Fetch system backups called');
    var payload = await RestClient.rpc(RPC.configBackupList);
    if (payload.metadata.success) {
      var mappedItems = (jsonDecode(payload.postJson) as List).map((e) => e.toString()).toList();
      backupList.assignAll(mappedItems);
    } else {
      displayWarning('Failed to fetch backups');
    }
  }

  Future<void> createBackup() async {
    developer.log('Create system backup called');
    var payload = await RestClient.rpc(RPC.configBackupCreate);
    if (payload.metadata.success) {
      await fetchBackups();
    } else {
      displayWarning('Failed to create system backup');
    }
  }

  Future<void> deleteBackup(int index) async {
    developer.log('delete system backup called');
    var reqParam = {'id': index};
    var payload = await RestClient.rpc(RPC.configBackupDelete, parameters: reqParam);
    if (payload.metadata.success) {
      await fetchBackups();
    }
  }

  Future<void> restoreBackup(int index) async {
    developer.log('Restore system backup called');
    bool accepted = await displayAlertModal('Warning', 'JVM should be restarted for the changes to take effect');
    if (accepted) {
      var reqParam = {'id': index};
      var payload = await RestClient.rpc(RPC.configBackupRestore, parameters: reqParam);
      if (payload.metadata.success) {
        await fetchBackups();
      }
    }
  }

  Future<void> downloadBackup(int id) async {
    var params = {
      'type': 'config',
      'id': id.toString(),
      'password': passwordEditingController.text,
    };
    await RestClient.download(params);
    Get.back();
    passwordEditingController.clear();
  }

  Future<void> uploadBackup(Uint8List bytes, String name) async {
    var success = await RestClient.upload(bytes, name, UploadType.config, passwordEditingController.text);
    if (success) {
      fetchBackups();
      Get.back();
      passwordEditingController.clear();
    } else {
      displayWarning('Failed to upload config file');
    }
  }
}
