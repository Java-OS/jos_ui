import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/filesystem_controller.dart';
import 'package:jos_ui/controller/system_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';
import 'package:jos_ui/model/filesystem_tree.dart';
import 'package:jos_ui/service/rest_client.dart';
import 'package:jos_ui/utils.dart';
import 'package:jos_ui/widget/text_field_box_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

var _systemController = Get.put(SystemController());
var _filesystemController = Get.put(FilesystemController());

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

Future<void> displayFilesystemTree(bool enableMakeDirectory, bool enableUploadFiles) async {
  var filesystemTree = _filesystemController.filesystemTree;
  var basePath = filesystemTree.value!.fullPath;
  var treeController = TreeController<FilesystemTree>(roots: filesystemTree.value!.childs ?? [], childrenProvider: (FilesystemTree node) => node.childs ?? []);
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeaderAdvanced(
          title: 'Filesystem directory tree',
          actionButtons: [
            Visibility(
              visible: enableMakeDirectory,
              child: IconButton(
                onPressed: () => addFolderDialog(basePath,basePath, treeController),
                padding: EdgeInsets.zero,
                splashRadius: 10,
                icon: Icon(MdiIcons.folderPlusOutline, size: 16, color: Colors.white),
              ),
            ),
            Visibility(
              visible: enableUploadFiles,
              child: IconButton(
                onPressed: () => uploadFile(basePath, treeController),
                padding: EdgeInsets.zero,
                splashRadius: 10,
                icon: Icon(MdiIcons.uploadOutline, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          SizedBox(
            width: 600,
            height: 300,
            child: AnimatedTreeView(
              treeController: treeController,
              nodeBuilder: (BuildContext context, TreeEntry<FilesystemTree> entry) {
                _systemController.dateTimeZone;
                var nodePath = entry.node.fullPath;
                var isFile = entry.node.isFile;
                return InkWell(
                  onTap: () {
                    if (!entry.node.isFile) {
                      _filesystemController.fetchFilesystemTree(entry.node.fullPath);
                      treeController.toggleExpansion(entry.node);
                    }
                  },
                  child: TreeIndentation(
                    entry: entry,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            FolderButton(isOpen: !entry.node.isFile ? entry.isExpanded : null),
                            Text(truncate(entry.node.name), style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        Row(
                          children: [
                            Visibility(
                              visible: isFile,
                              child: IconButton(
                                onPressed: () => _filesystemController.download(nodePath),
                                splashRadius: 16,
                                icon: Icon(
                                  MdiIcons.download,
                                  color: Colors.black,
                                  size: 16,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: !isFile,
                              child: IconButton(
                                onPressed: () => addFolderDialog(basePath,nodePath, treeController),
                                splashRadius: 16,
                                icon: Icon(
                                  MdiIcons.folderPlusOutline,
                                  color: Colors.black,
                                  size: 16,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: !isFile,
                              child: IconButton(
                                onPressed: () => uploadFile(nodePath, treeController),
                                padding: EdgeInsets.zero,
                                splashRadius: 16,
                                icon: Icon(
                                  MdiIcons.uploadOutline,
                                  size: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => deleteConfirmationDialog(basePath, nodePath, treeController),
                              splashRadius: 16,
                              icon: Icon(
                                MdiIcons.delete,
                                color: Colors.black,
                                size: 16,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    },
  ).then((value) => _filesystemController.clear());
}

Future<void> uploadFile(String basePath, TreeController<FilesystemTree> treeController) async {
  var picked = await FilePickerWeb.platform.pickFiles();
  if (picked != null) {
    var bytes = picked.files.single.bytes!;
    var fileName = picked.files.single.name;
    await RestClient.uploadFile(bytes, fileName, basePath);
    await _filesystemController.fetchFilesystemTree(basePath);
    treeController.rebuild();
  }
}

Future<void> addFolderDialog(String basePath,String path, TreeController treeController) async {
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
                  await _filesystemController.createDir(path);
                  await _filesystemController.fetchFilesystemTree(basePath).then((_) => treeController.rebuild());
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

Future<void> deleteConfirmationDialog(String basePath, String path, TreeController treeController) async {
  var displayPath = path.replaceAll(basePath, '');
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Confirm delete'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [Text('You want to delete: '), Text(displayPath, style: TextStyle(fontWeight: FontWeight.bold))]),
              SizedBox(height: 8),
              Text('Are you sure ?'),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    child: Text('Confirm'),
                    onPressed: () async {
                      await _filesystemController.delete(path);
                      await _filesystemController.fetchFilesystemTree(basePath).then((_) => treeController.rebuild());
                      Get.back();
                    },
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    child: Text('Cancel'),
                    onPressed: () => Get.back(),
                  ),
                ],
              )
            ],
          )
        ],
      );
    },
  );
}
