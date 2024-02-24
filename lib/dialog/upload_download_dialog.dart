import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/backup_controller.dart';
import 'package:jos_ui/widget/text_field_box_widget.dart';

BackupController _backupController = Get.put(BackupController());

Future<void> displayDownloadConfigModal(int index, BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Secure download'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldBox(isPassword: true, controller: _backupController.passwordEditingController, label: 'Password'),
              SizedBox(height: 10),
              Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: () => _backupController.downloadBackup(index), child: Text('Download'))),
            ],
          )
        ],
      );
    },
  );
}

Future<void> displayUploadConfigModal(String name, Uint8List bytes, BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Secure download'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              TextFieldBox(isPassword: true, controller: _backupController.passwordEditingController, label: 'Password'),
              SizedBox(height: 10),
              Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: () => _backupController.uploadBackup(bytes, name), child: Text('Upload'))),
            ],
          )
        ],
      );
    },
  );
}
