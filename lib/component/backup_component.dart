import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/backup_controller.dart';

class BackupComponent extends StatefulWidget {
  const BackupComponent({super.key});

  @override
  State<BackupComponent> createState() => BackupComponentState();
}

class BackupComponentState extends State<BackupComponent> {
  final BackupController _backupController = Get.put(BackupController());

  int hoverIndex = -1;

  @override
  void initState() {
    super.initState();
    _backupController.fetchBackups();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                message: 'Make backup',
                preferBelow: false,
                child: OutlinedButton(
                  onPressed: () => _backupController.uploadBackup(),
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

                  bool effectStatement = (hoverIndex == index && index != 0);
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: MouseRegion(
                      onHover: (_) => setState(() => hoverIndex = index),
                      onExit: (_) => setState(() => hoverIndex = -1),
                      child: Material(
                        elevation: effectStatement ? 2 : 0,
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(5),
                        child: AnimatedContainer(
                          decoration: BoxDecoration(
                            border: Border.all(color: effectStatement ? Colors.blue : Colors.grey.shade400, width: 0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          duration: Duration(milliseconds: 500),
                          child: ListTile(
                            leading: index == 0 ? null : CircleAvatar(radius: 12, child: Text(index.toString(), style: TextStyle(fontSize: 12))),
                            title: Text(title, style: TextStyle(fontSize: 14)),
                            trailing: SizedBox(
                              width: 120,
                              child: getTilButtons(index),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
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

  Row getTilButtons(int index) {
    return Row(
      children: [
        IconButton(onPressed: () => _backupController.downloadBackup(index), icon: Icon(Icons.file_download_outlined, size: 16, color: Colors.black), splashRadius: 20),
        Visibility(visible: index != 0, child: IconButton(onPressed: () => _backupController.restoreBackup(index), icon: Icon(Icons.restore, size: 16, color: Colors.black), splashRadius: 20)),
        Visibility(visible: index != 0, child: IconButton(onPressed: () => _backupController.deleteBackup(index), icon: Icon(Icons.delete, size: 16, color: Colors.black), splashRadius: 20)),
      ],
    );
  }
}
