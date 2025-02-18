import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/text_field_box.dart';
import 'package:jos_ui/controller/filesystem_controller.dart';
import 'package:jos_ui/controller/system_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';
import 'package:jos_ui/model/filesystem_tree.dart';
import 'package:jos_ui/service/rest_client.dart';

var _filesystemController = Get.put(FilesystemController());

final _verticalController = ScrollController();
final _horizontalController = ScrollController();

Future<void> displayMountFilesystemModal() async {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Mount filesystem'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              TextFieldBox(label: 'Partition', controller: _filesystemController.partitionEditingController, isEnable: false),
              SizedBox(height: 8),
              TextFieldBox(controller: _filesystemController.mountPointEditingController, label: 'Mount Point'),
              SizedBox(height: 8),
              TextFieldBox(label: 'Filesystem', controller: _filesystemController.filesystemTypeEditingController, isEnable: false),
              SizedBox(height: 8),
              Obx(
                () => CheckboxListTile(
                  title: Text('Mount on startup', style: TextStyle(fontSize: 14)),
                  value: _filesystemController.mountOnStartUp.value,
                  onChanged: (e) => _filesystemController.mountOnStartUp.value = e!,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => _filesystemController.mount(),
                  child: Text('Mount'),
                ),
              )
            ],
          )
        ],
      );
    },
  );
}

Future<void> uploadFile(String basePath, TreeController<FilesystemTree> treeController) async {
  var picked = await FilePicker.platform.pickFiles();
  if (picked != null) {
    var bytes = picked.files.single.bytes!;
    var fileName = picked.files.single.name;
    await RestClient.uploadFile(bytes, fileName, basePath);
    await _filesystemController.fetchFilesystemTree(basePath);
    treeController.rebuild();
  }
}

Future<void> addFolderDialog() async {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Create new folder'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldBox(controller: _filesystemController.newFolderEditingController, label: 'Folder name'),
              SizedBox(height: 8),
              ElevatedButton(
                child: Text('Confirm'),
                onPressed: () async {
                  await _filesystemController.createDir(_filesystemController.directoryPath.value);
                  Get.back();
                },
              )
            ],
          )
        ],
      );
    },
  );
}

Future<void> deleteConfirmationDialog() async {
  var list = _filesystemController.selectedItems.map((e) => Text(e, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12))).toList();
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Confirm delete'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Text('You want to delete: '),
          Container(
            constraints: BoxConstraints(maxHeight: 300, maxWidth: 280),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Scrollbar(
              controller: _horizontalController,
              thumbVisibility: true,
              trackVisibility: true,
              child: SingleChildScrollView(
                controller: _horizontalController,
                scrollDirection: Axis.horizontal,
                physics: AlwaysScrollableScrollPhysics(),
                child: Scrollbar(
                  controller: _verticalController,
                  thumbVisibility: true,
                  trackVisibility: true,
                  child: SingleChildScrollView(
                    controller: _verticalController,
                    scrollDirection: Axis.vertical,
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: list,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text('Are you sure ?'),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(
                child: Text('Confirm'),
                onPressed: () async {
                  await _filesystemController.delete();
                  Get.back();
                },
              ),
              SizedBox(width: 8),
              ElevatedButton(
                child: Text('Cancel'),
                onPressed: () => Get.back(),
              ),
            ],
          ),
        ],
      );
    },
  );
}
