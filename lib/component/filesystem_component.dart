import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/system_controller.dart';
import 'package:jos_ui/dialog/filesystem_dialog.dart';
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
    _systemController.fetchPartitions();
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
    var filesystems = _systemController.partitions;
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
                  current: fs.type == 'LVM2_member' ? fs.total : used,
                  text: getPartitionText(fs),
                  warn: fs.type == 'LVM2_member' ? Colors.grey : Colors.red,
                  textStyle: TextStyle(fontSize: 12),
                  onClick: () => fs.type == 'LVM2_member' ? null : fetchTreeAndDisplay(fs),
                  disabled: fs.type == 'LVM2_member',
                ),
              ),
              SizedBox(width: 8),
              CharButton(
                width: 70,
                height: 30,
                char: getButtonName(fs),
                textStyle: getButtonTextStyle(fs),
                onPressed: () => fs.type == 'LVM2_member' ? null : actionButton(fs),
              ),
            ],
          ),
        ),
      );
    }

    return list;
  }

  void actionButton(HDDPartition partition) {
    print('Type ${partition.type}   ${partition.total}');
    if (partition.type == 'swap') {
      partition.total == 0 ? _systemController.swapOn(partition) : _systemController.swapOff(partition);
    } else if (partition.mountPoint == null || partition.mountPoint!.isEmpty) {
      _systemController.clear();
      _systemController.partitionEditingController.text = partition.partition;
      _systemController.filesystemTypeEditingController.text = partition.type;
      displayMountFilesystemModal(context);
    } else {
      _systemController.umount(partition);
    }
  }

  String getPartitionText(HDDPartition fs) {
    if (fs.type == 'LVM2_member') {
      return '${fs.partition} -> [ LVM ]   ';
    } else if (fs.type == 'swap') {
      return '${fs.partition} -> [ SWAP ]   ';
    } else {
      return '${fs.partition} -> [ ${fs.mountPoint ?? ''} ]   ';
    }
  }

  TextStyle getButtonTextStyle(HDDPartition partition) {
    if (partition.type == 'swap') {
      return TextStyle(
        fontSize: 11,
        color: Colors.black,
        fontWeight: partition.total != 0 ? FontWeight.normal : FontWeight.bold,
      );
    } else {
      return TextStyle(
        fontSize: 11,
        color: Colors.black,
        fontWeight: (partition.mountPoint == null || partition.mountPoint!.isEmpty) ? FontWeight.bold : FontWeight.normal,
      );
    }
  }

  String getButtonName(HDDPartition fs) {
    if (fs.type == 'swap') {
      return fs.total == 0 ? 'swap on' : 'swap off';
    } else if (fs.type == 'LVM2_member') {
      return ' - ';
    } else {
      return (fs.mountPoint == null || fs.mountPoint!.isEmpty) ? 'Mount' : 'Disconnect';
    }
  }

  fetchTreeAndDisplay(HDDPartition partition) {
    _systemController.mountPointEditingController.text = partition.mountPoint!;
    _systemController.fetchFilesystemTree().then((value) => displayFilesystemTree(context));
  }
}
