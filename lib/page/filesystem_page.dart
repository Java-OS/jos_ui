import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/bar_chart.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/component/char_button.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/filesystem_controller.dart';
import 'package:jos_ui/dialog/filesystem_dialog.dart';
import 'package:jos_ui/model/filesystem.dart';

class FilesystemPage extends StatefulWidget {
  const FilesystemPage({super.key});

  @override
  State<FilesystemPage> createState() => _FilesystemPageState();
}

class _FilesystemPageState extends State<FilesystemPage> {
  final _filesystemController = Get.put(FilesystemController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _filesystemController.fetchPartitions());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContent(
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
    var filesystems = _filesystemController.partitions;
    for (var fs in filesystems) {
      int used = 0;
      if (fs.freeSize != null && fs.freeSize == 0) {
        used = fs.totalSize;
      } else if (fs.freeSize != null) {
        used = fs.totalSize - (fs.freeSize as int);
      }
      print('>>>>>>>>>>>>>> ${fs.totalSize}  ${fs.freeSize} $used');
      list.add(
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Expanded(
                child: BarChart(
                  total: fs.totalSize,
                  current: fs.type == 'LVM2_member' ? fs.totalSize : used,
                  text: getPartitionText(fs),
                  warn: fs.type == 'LVM2_member' ? Colors.grey : Colors.red,
                  textStyle: TextStyle(fontSize: 12),
                  onClick: canUsePartition(fs) ? null : () => fetchTreeAndDisplay(fs),
                  disabled: canUsePartition(fs),
                ),
              ),
              SizedBox(width: 8),
              CharButton(
                width: 70,
                height: 30,
                char: getButtonName(fs),
                textStyle: getButtonTextStyle(fs),
                onPressed: fs.type == 'LVM2_member' || fs.type.isEmpty || fs.mountPoint == '/' ? null : () => actionButton(fs),
              ),
            ],
          ),
        ),
      );
    }

    return list;
  }

  bool canUsePartition(PartitionInformation fs) => fs.type == 'swap' || fs.mountPoint.isEmpty || fs.type == 'LVM2_member' || fs.type.isEmpty;

  void actionButton(PartitionInformation partition) {
    if (partition.type == 'swap') {
      partition.totalSize == 0 ? _filesystemController.swapOn(partition) : _filesystemController.swapOff(partition);
    } else if (partition.mountPoint.isEmpty) {
      _filesystemController.clear();
      _filesystemController.partitionEditingController.text = partition.blk;
      _filesystemController.filesystemTypeEditingController.text = partition.type;
      displayMountFilesystemModal();
    } else {
      _filesystemController.umount(partition);
    }
  }

  String getPartitionText(PartitionInformation fs) {
    if (fs.type == 'LVM2_member') {
      return '${fs.blk} -> [ LVM ]   ';
    } else if (fs.type == 'swap') {
      return '${fs.blk} -> [ SWAP ]   ';
    } else {
      return '${fs.blk} -> [ ${fs.mountPoint} ]   ';
    }
  }

  TextStyle getButtonTextStyle(PartitionInformation partition) {
    if (partition.type == 'swap') {
      return TextStyle(
        fontSize: 11,
        color: Colors.black,
        fontWeight: partition.totalSize != 0 ? FontWeight.normal : FontWeight.bold,
      );
    } else {
      return TextStyle(
        fontSize: 11,
        color: Colors.black,
        fontWeight: (partition.mountPoint.isEmpty) ? FontWeight.bold : FontWeight.normal,
      );
    }
  }

  String getButtonName(PartitionInformation fs) {
    if (fs.type == 'swap') {
      return fs.totalSize == 0 ? 'swap on' : 'swap off';
    } else if (fs.type == 'LVM2_member' || fs.type.isEmpty || fs.mountPoint == '/') {
      return ' - ';
    } else {
      return (fs.mountPoint.isEmpty) ? 'Mount' : 'Disconnect';
    }
  }

  fetchTreeAndDisplay(PartitionInformation partition) async {
    _filesystemController.directoryPath.value = partition.mountPoint;
    await _filesystemController.fetchFilesystemTree().then((_) => Get.toNamed(Routes.directoryTree.path));
    // .then((value) => displayFilesystemTree(true, false));
  }
}
