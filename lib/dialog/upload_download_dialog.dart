import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/text_field_box.dart';
import 'package:jos_ui/controller/backup_controller.dart';
import 'package:jos_ui/controller/upload_download_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';

var _backupController = Get.put(BackupController());
var _uploadDownloadController = Get.put(UploadDownloadController());

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

Future<void> displayUploadProgress() async {
  showDialog(
    barrierDismissible: false,
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(3)),
        contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        content: SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_uploadDownloadController.inProgressItem.value, style: TextStyle(fontSize: 12, color: Colors.white)),
                  Text('${_uploadDownloadController.index.value}/${_uploadDownloadController.count.value}', style: TextStyle(fontSize: 12, color: Colors.white)),
                  LinearProgressIndicator(color: Colors.lightGreenAccent, value: _uploadDownloadController.percentage.value),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: OutlinedButton(
                      onPressed: () {
                        _uploadDownloadController.isCancel.value = true;
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.grey)),
                      child: Text('Cancel', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
