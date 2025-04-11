import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/text_field_box.dart';
import 'package:jos_ui/controller/filesystem_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';
import 'package:jos_ui/dialog/event_dialog.dart';

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

Future<void> addFolderDialog() async {
  Get.back();
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
                  _filesystemController.createDir();
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

Future<void> deleteConfirmationDialog(bool closeContextMenu) async {
  if (closeContextMenu) Get.back();
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
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 300),
              child: Scrollbar(
                controller: _verticalController,
                thumbVisibility: true,
                trackVisibility: true,
                child: SingleChildScrollView(
                  controller: _verticalController,
                  scrollDirection: Axis.vertical,
                  physics: AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 280),
                    child: Scrollbar(
                      controller: _horizontalController,
                      thumbVisibility: true,
                      trackVisibility: true,
                      child: SingleChildScrollView(
                        controller: _horizontalController,
                        scrollDirection: Axis.horizontal,
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(_filesystemController.selectedItems.length, (index) {
                            return Text(_filesystemController.selectedItems[index], style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12));
                          }),
                        ),
                      ),
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
                  Get.back();
                  _filesystemController.delete().then((_) => Get.back());
                  displayEvent();
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

Future<void> compressDialog() async {
  Get.back();
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Create archive'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldBox(controller: _filesystemController.archiveFileNameEditingController, label: 'file name'),
              SizedBox(height: 8),
              ElevatedButton(
                child: Text('Confirm'),
                onPressed: () async {
                  Get.back();
                  _filesystemController.createArchive();
                  displayEvent();
                },
              )
            ],
          )
        ],
      );
    },
  );
}
