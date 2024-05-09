import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/widget/tile_widget.dart';
import 'package:jos_ui/controller/backup_controller.dart';
import 'package:jos_ui/dialog/upload_download_dialog.dart';

class TabBackup extends StatefulWidget {
  const TabBackup({super.key});

  @override
  State<TabBackup> createState() => _TabBackupState();
}

class _TabBackupState extends State<TabBackup> {
  final _backupController = Get.put(BackupController());
  int hoverIndex = -1;

  @override
  void initState() {
    super.initState();
    _backupController.fetchBackups();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Backup', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
        Divider(),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Tooltip(
                    message: 'Make backup',
                    preferBelow: false,
                    child: OutlinedButton(
                      onPressed: () => _backupController.createBackup(),
                      child: Icon(Icons.add, size: 16, color: Colors.black),
                    ),
                  ),
                  Tooltip(
                    message: 'Upload backup',
                    preferBelow: false,
                    child: OutlinedButton(
                      onPressed: () => chooseConfigFile(),
                      child: Icon(Icons.upload_file_outlined, size: 16, color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    itemCount: _backupController.backupList.length,
                    itemBuilder: (BuildContext context, int index) {
                      String fileName = _backupController.backupList[index];
                      late String title = 'Current';
                      if (index != 0 && fileName.contains('uploaded')) {
                        fileName = fileName.substring(21);
                        title = '${parseConfigTitle(fileName, title)}   Uploaded';
                      } else if (index != 0) {
                        fileName = fileName.substring(12);
                        title = parseConfigTitle(fileName, title);
                      }

                     return Padding(
                       padding: const EdgeInsets.all(4.0),
                       child: TileItem(
                          index: index,
                          title: Text(title, style: TextStyle(fontSize: 14)),
                          actions: SizedBox(
                            width: 120,
                            child: getTilButtons(index),
                          ),
                        ),
                     );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String parseConfigTitle(String fileName, String title) {
    var year = fileName.substring(0, 4).toString();
    var month = fileName.substring(4, 6).toString();
    var day = fileName.substring(6, 8).toString();
    var hour = fileName.substring(9, 11).toString();
    var minute = fileName.substring(12, 14).toString();
    return '$year/$month/$day $hour:$minute';
  }

  Widget getTilButtons(int index) {
    return Row(
      children: [
        IconButton(onPressed: () => displayDownloadConfigModal(index, context), icon: Icon(Icons.file_download_outlined, size: 16, color: Colors.black), splashRadius: 20),
        Visibility(visible: index != 0, child: IconButton(onPressed: () => _backupController.restoreBackup(index), icon: Icon(Icons.restore, size: 16, color: Colors.black), splashRadius: 20)),
        Visibility(visible: index != 0, child: IconButton(onPressed: () => _backupController.deleteBackup(index), icon: Icon(Icons.delete, size: 16, color: Colors.black), splashRadius: 20)),
      ],
    );
  }

  Future<void> chooseConfigFile() async {
    var picked = await FilePickerWeb.platform.pickFiles();
    if (picked != null) {
      var bytes = picked.files.single.bytes!;
      var name = picked.files.single.name;
      displayUploadConfigModal(name, bytes);
    }
  }
}
