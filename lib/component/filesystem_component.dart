import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/system_controller.dart';
import 'package:jos_ui/dialog/filesystem_dialog.dart';
import 'package:jos_ui/widget/bar_chart.dart';
import 'package:jos_ui/widget/char_button.dart';

class FilesystemComponent extends StatefulWidget {
  const FilesystemComponent({super.key});

  @override
  State<FilesystemComponent> createState() => _FilesystemComponentState();
}

class _FilesystemComponentState extends State<FilesystemComponent> {
  final SystemController _systemController = Get.put(SystemController());

  @override
  void initState() {
    _systemController.fetchFilesystems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: filesystemWidgets(),
          ),
        ),
      ),
    );
  }

  List<Widget> filesystemWidgets() {
    var list = <Widget>[];
    var filesystems = _systemController.filesystems;
    for (var fs in filesystems) {
      int used = fs.free != null ? fs.total - (fs.free as int) : 0;
      list.add(
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Expanded(child: BarChart(total: fs.total, current: used, text: '${fs.partition} -> [ ${fs.mountPoint ?? ''} ]   ', warn: Colors.red)),
              SizedBox(width: 8),
              CharButton(width: 70, height: 30, char: fs.mountPoint == null ? 'Mount' : 'Disconnect',fontWeight: fs.mountPoint == null ? FontWeight.bold : FontWeight.normal, onPressed: () => fs.mountPoint == null ? mountFilesystem(fs.partition) : disconnectFilesystem(fs.mountPoint!)),
            ],
          ),
        ),
      );
    }

    return list;
  }

  void mountFilesystem(String partition) {
    _systemController.partitionEditingController.text = partition;
    displayMountFilesystemModal(context);
  }

  void disconnectFilesystem(String mountPoint) {
    _systemController.mountPointEditingController.text = mountPoint;
    _systemController.umountFilesystem();
  }
}
