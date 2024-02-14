import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/system_controller.dart';
import 'package:jos_ui/model/filesystem_tree.dart';
import 'package:jos_ui/widget/text_field_box_widget.dart';

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
              TextFieldBox(label: 'Partition', controller: _systemController.partitionEditingController, isEnable: false),
              SizedBox(height: 8),
              TextFieldBox(controller: _systemController.mountPointEditingController, label: 'Mount Point'),
              SizedBox(height: 8),
              TextFieldBox(label: 'Filesystem', controller: _systemController.filesystemTypeEditingController, isEnable: false),
              SizedBox(height: 8),
              Obx(
                () => CheckboxListTile(
                  title: Text('Mount on startup', style: TextStyle(fontSize: 14)),
                  value: _systemController.mountOnStartUp.value,
                  onChanged: (e) => _systemController.mountOnStartUp.value = e!,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => _systemController.mount(),
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

Future<void> displayFilesystemTree(BuildContext context) async {
  final treeController = TreeController<FilesystemTree>(roots: _systemController.filesystemTree.value!.childs ?? [], childrenProvider: (FilesystemTree node) => node.childs ?? []);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Filesystem directory tree'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          SizedBox(
            width: 900,
            height: 400,
            child: AnimatedTreeView(
              treeController: treeController,
              nodeBuilder: (BuildContext context, TreeEntry<FilesystemTree> entry) {
                _systemController.dateTimeZone;
                return InkWell(
                  onTap: () => {
                    if (!entry.node.isFile) {_systemController.fetchFilesystemTree(entry.node.fullPath), treeController.toggleExpansion(entry.node)}
                  },
                  child: TreeIndentation(
                    entry: entry,
                    child: Row(
                      children: [
                        FolderButton(isOpen: !entry.node.isFile ? entry.isExpanded : null),
                        Text(entry.node.name, style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      );
    },
  ).then((value) => _systemController.clear());
}