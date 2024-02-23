import 'dart:convert';
import 'dart:developer' as developer;

import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:get/get.dart';
import 'package:jos_ui/dialog/alert_dialog.dart';
import 'package:jos_ui/dialog/toast.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/service/rest_client.dart';

class BackupController extends GetxController {
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
    await RestClient.download({'type': 'config', 'id': id.toString()});
  }

  Future<void> uploadBackup() async {
    var picked = await FilePickerWeb.platform.pickFiles();
    if (picked != null) {
      var uploaded = await RestClient.upload(picked.files.single.bytes!, picked.files.single.name, UploadType.config);
      if (uploaded) fetchBackups();
    }
  }
}
