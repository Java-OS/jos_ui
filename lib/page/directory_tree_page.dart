import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/component/directory_path.dart';
import 'package:jos_ui/component/file_view.dart';
import 'package:jos_ui/component/key_value.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/filesystem_controller.dart';
import 'package:jos_ui/dialog/filesystem_dialog.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DirectoryTreePage extends StatefulWidget {
  const DirectoryTreePage({super.key});

  @override
  State<DirectoryTreePage> createState() => _DirectoryTreePageState();
}

class _DirectoryTreePageState extends State<DirectoryTreePage> {
  final _filesystemController = Get.put(FilesystemController());

  @override
  void initState() {
    if (_filesystemController.filesystemTree.value == null) WidgetsBinding.instance.addPostFrameCallback((_) => Get.offAllNamed(Routes.filesystem.path));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CardContent(
        controllers: [
          Tooltip(
            message: 'Create new folder',
            child: OutlinedButton(
              onPressed: () => addFolderDialog(),
              child: Icon(Icons.create_new_folder_outlined, size: 16, color: Colors.black),
            ),
          ),
          Tooltip(
            message: 'Upload file',
            child: OutlinedButton(
              onPressed: () => {},
              child: Icon(Icons.download_outlined, size: 16, color: Colors.black),
            ),
          ),
          Tooltip(
            message: 'Download file',
            child: OutlinedButton(
              onPressed: isAnySelected() ? () => {} : null,
              child: Icon(Icons.upload_outlined, size: 16, color: isAnySelected() ? Colors.black : Colors.grey),
            ),
          ),
          Tooltip(
            message: 'Select all files',
            child: OutlinedButton(
              onPressed: () => selectAllItems(),
              child: Icon(Icons.select_all, size: 16, color: Colors.black),
            ),
          ),
          Tooltip(
            message: 'deselect files',
            child: OutlinedButton(
              onPressed: isAnySelected() ? () => deselectAllItems() : null,
              child: Icon(Icons.deselect, size: 16, color: isAnySelected() ? Colors.black : Colors.grey),
            ),
          ),
          Tooltip(
            message: 'delete selected files',
            child: OutlinedButton(
              onPressed: isAnySelected() ? () => deleteConfirmationDialog() : null,
              child: Icon(MdiIcons.trashCanOutline, size: 16, color: isAnySelected() ? Colors.black : Colors.grey),
            ),
          )
        ],
        child: Expanded(
          child: SizedBox(
            width: double.infinity,
            child: Obx(
              () => Column(
                spacing: 4,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (hasDirectoryPath()) DirectoryPath(path: _filesystemController.directoryPath.value, onClick: (e) => enterFolder(e)),
                      Row(
                        spacing: 4,
                        children: [
                          KeyValue(
                            k: 'selected',
                            v: '${_filesystemController.selectedItems.length}/${_filesystemController.filesystemTree.value!.childs!.length}',
                            keyTextColor: Colors.white,
                            valueTextColor: Colors.white,
                            keyBackgroundColor: Colors.brown,
                            valueBackgroundColor: Colors.pinkAccent,
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 2),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(border: Border.all(color: Colors.black12, width: 1)),
                      child: GridView.builder(
                        padding: EdgeInsets.all(8),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 150,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1,
                        ),
                        itemCount: _filesystemController.filesystemTree.value!.childs!.length,
                        itemBuilder: (BuildContext context, int index) {
                          var child = _filesystemController.filesystemTree.value!.childs![index];
                          return FileView(
                            isSelected: _filesystemController.selectedItems.contains(child.fullPath),
                            filesystemTree: child,
                            onDoubleClick: child.isFile ? null : () => enterFolder(child.fullPath),
                            onSelect: () => selectItem(child.fullPath),
                            onDeselect: () => deselectItem(child.fullPath),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void selectAllItems() {
    _filesystemController.selectedItems.clear();
    _filesystemController.selectedItems.addAll(_filesystemController.filesystemTree.value!.childs!.map((e) => e.fullPath).toList());
  }

  void deselectAllItems() => _filesystemController.selectedItems.clear();

  bool hasDirectoryPath() => _filesystemController.directoryPath.isNotEmpty;

  void selectItem(String fullPath) => _filesystemController.selectedItems.add(fullPath);

  void deselectItem(String fullPath) => _filesystemController.selectedItems.remove(fullPath);

  bool isSelected(String fullPath) => _filesystemController.selectedItems.contains(fullPath);

  bool isAnySelected() => _filesystemController.selectedItems.isNotEmpty;

  void enterFolder(String fullPath) {
    _filesystemController.directoryPath.value = fullPath;
    _filesystemController.fetchFilesystemTree(fullPath);
    _filesystemController.selectedItems.clear();
  }

  @override
  void dispose() {
    _filesystemController.clear();
    super.dispose();
  }
}
