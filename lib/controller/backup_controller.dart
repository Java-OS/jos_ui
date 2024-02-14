import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/dialog/toast.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/service/rest_client.dart';

class BackupController extends GetxController {
  var backupList = <String>[].obs;


  Future<void> fetchBackups() async {
    developer.log('Fetch system backups called');
    var response = await RestClient.rpc(RPC.configBackupList);
    if (response.result != null) {
      var mappedItems = (response.result as List).map((e) => e.toString()).toList();
      backupList.assignAll(mappedItems);
    } else {
      displayWarning('Failed to fetch backups');
    }
  }

  Future<void> createBackup() async {
    developer.log('Create system backup called');
    var response = await RestClient.rpc(RPC.configBackupCreate);
    if (response.success) {
      await fetchBackups();
    } else {
      displayWarning('Failed to create system backup');
    }
  }

  Future<void> deleteBackup(int index) async {
    developer.log('delete system backup called');
    var reqParam = {'id': index};
    var response = await RestClient.rpc(RPC.configBackupDelete, parameters: reqParam);
    if (response.success) {
      await fetchBackups();
    }
  }

  Future<void> restoreBackup(int index) async {
    developer.log('Restore system backup called');
    var reqParam = {'id': index};
    var response = await RestClient.rpc(RPC.configBackupRestore, parameters: reqParam);
    if (response.success) {
      await fetchBackups();
    }
  }
}
