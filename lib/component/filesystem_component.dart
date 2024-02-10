import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/system_controller.dart';
import 'package:jos_ui/dialog/filesystem_dialog.dart';
import 'package:jos_ui/dialog/toast.dart';
import 'package:jos_ui/model/filesystem.dart';
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
              Expanded(
                child: BarChart(
                  total: fs.total,
                  current: used,
                  text: '${fs.partition} -> [ ${fs.mountPoint ?? ''} ]   ',
                  warn: Colors.red,
                  textStyle: TextStyle(fontSize: 12),
                  onClick: () => fetchTreeAndDisplay(fs),
                ),
              ),
              SizedBox(width: 8),
              CharButton(
                width: 70,
                height: 30,
                char: getButtonName(fs),
                fontWeight: (fs.mountPoint == null || fs.mountPoint!.isEmpty) ? FontWeight.bold : FontWeight.normal,
                onPressed: () => fs.mountPoint == null ? mountFilesystem(fs.partition) : disconnectFilesystem(fs.mountPoint!),
              ),
            ],
          ),
        ),
      );
    }

    return list;
  }

  String getButtonName(HDDPartition fs) {
    var swapIsOff = fs.type == 'swap' && fs.total == 0;
    return (fs.mountPoint == null || fs.mountPoint!.isEmpty) ? swapIsOff ? 'swap on' : 'Mount' : !swapIsOff ? 'swap off' : 'Disconnect';
  }

  fetchTreeAndDisplay(HDDPartition partition) {
      _systemController.mountPointEditingController.text = partition.mountPoint!;
      _systemController.fetchFilesystemTree().then((value) => displayFilesystemTree(context));
  }

  void mountFilesystem(String partition) {
    debugPrint(partition);
    _systemController.partitionEditingController.text = partition;
    displayMountFilesystemModal(context);
  }

  void disconnectFilesystem(String mountPoint) {
    _systemController.mountPointEditingController.text = mountPoint;
    _systemController.umountFilesystem();
  }
}
