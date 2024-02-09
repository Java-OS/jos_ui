import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/system_controller.dart';
import 'package:jos_ui/model/filesystem_type.dart';
import 'package:jos_ui/widget/drop_down_widget.dart';
import 'package:jos_ui/widget/text_box_widget.dart';

SystemController _systemController = Get.put(SystemController());

Future<void> displayMountFilesystemModal(BuildContext context) async {
  showDialog(
    context: context,
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
              TextBox(label: 'Filesystem', controller: _systemController.partitionEditingController, isEnable: false),
              SizedBox(height: 8),
              TextBox(controller: _systemController.mountPointEditingController, label: 'Mount Point'),
              SizedBox(height: 8),
              DropDownMenu<FilesystemType>(
                displayClearButton: false,
                value: _systemController.filesystemType.value,
                hint: Text(_systemController.filesystemType.value.name),
                items: FilesystemType.values.map((e) => DropdownMenuItem<FilesystemType>(value: e, child: Text(e.name))).toList(),
                onChanged: (value) => _systemController.filesystemType.value = value,
              ),
              SizedBox(height: 8),
              Obx(
                () => CheckboxListTile(
                  title: Text('Mount on startup',style: TextStyle(fontSize: 14)),
                  value: _systemController.mountOnStartUp.value,
                  onChanged: (e) => _systemController.mountOnStartUp.value = e!,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => _systemController.mountFilesystem(),
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
