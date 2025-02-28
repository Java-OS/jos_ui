import 'package:contextmenu_plus/contextmenu_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/component/directory_path.dart';
import 'package:jos_ui/component/file_view.dart';
import 'package:jos_ui/component/key_value.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/filesystem_controller.dart';
import 'package:jos_ui/dialog/filesystem_dialog.dart';
import 'package:jos_ui/dialog/progress_dialog.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DirectoryTreePage extends StatefulWidget {
  const DirectoryTreePage({super.key});

  @override
  State<DirectoryTreePage> createState() => _DirectoryTreePageState();
}

class _DirectoryTreePageState extends State<DirectoryTreePage> {
  final _directoryPathScrollController = ScrollController();
  final _filesystemController = Get.put(FilesystemController());
  double dx = 0;
  double dy = 0;
  var isOnHover = false;

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
          if (isAnyItemOnAction())
            Tooltip(
              message: 'Paste',
              child: OutlinedButton(
                onPressed: () => {displayEvent(), _filesystemController.paste()},
                child: Icon(Icons.paste, size: 16, color: Colors.black),
              ),
            ),
          if (isAnySelected())
            Tooltip(
              message: 'Delete',
              child: OutlinedButton(
                onPressed: () => deleteItems(),
                child: Icon(MdiIcons.trashCanOutline, size: 16, color: Colors.black),
              ),
            ),
          if (isAnySelected())
            Tooltip(
              message: 'Copy',
              child: OutlinedButton(
                onPressed: () => setCopyItems(),
                child: Icon(Icons.copy_outlined, size: 16, color: Colors.black),
              ),
            ),
          if (isAnySelected())
            Tooltip(
              message: 'Cut',
              child: OutlinedButton(
                onPressed: () => setCutItems(),
                child: Icon(Icons.cut_outlined, size: 16, color: Colors.black),
              ),
            ),
          Tooltip(
            message: 'Create new folder',
            child: OutlinedButton(
              onPressed: () => addFolderDialog(),
              child: Icon(Icons.create_new_folder_outlined, size: 16, color: Colors.black),
            ),
          ),
          Tooltip(
            message: 'Select all files',
            child: OutlinedButton(
              onPressed: () => selectAllItems(),
              child: Icon(Icons.select_all, size: 16, color: Colors.black),
            ),
          ),
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
                      if (hasDirectoryPath())
                        Expanded(
                          child: Scrollbar(
                            controller: _directoryPathScrollController,
                            child: SingleChildScrollView(
                              controller: _directoryPathScrollController,
                              physics: AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: DirectoryPath(
                                path: _filesystemController.directoryPath.value,
                                onClick: (e) => enterFolder(e),
                              ),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                          spacing: 4,
                          children: [
                            if (_filesystemController.cuteItems.isNotEmpty)
                              MouseRegion(
                                onHover: (e) => setState(() => isOnHover = true),
                                onExit: (e) => setState(() => isOnHover = false),
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () => _filesystemController.cuteItems.clear(),
                                  child: KeyValue(
                                    k: 'Cut',
                                    v: '${_filesystemController.cuteItems.length}',
                                    keyTextColor: Colors.white,
                                    valueTextColor: Colors.white,
                                    keyBackgroundColor: Colors.brown,
                                    valueBackgroundColor: Colors.pinkAccent,
                                  ),
                                ),
                              ),
                            if (_filesystemController.copyItems.isNotEmpty)
                              MouseRegion(
                                onHover: (e) => setState(() => isOnHover = true),
                                onExit: (e) => setState(() => isOnHover = false),
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () => _filesystemController.copyItems.clear(),
                                  child: KeyValue(
                                    k: 'Copy',
                                    v: '${_filesystemController.copyItems.length}',
                                    keyTextColor: Colors.white,
                                    valueTextColor: Colors.white,
                                    keyBackgroundColor: Colors.brown,
                                    valueBackgroundColor: Colors.pinkAccent,
                                  ),
                                ),
                              ),
                            MouseRegion(
                              onHover: (e) => setState(() => isOnHover = true),
                              onExit: (e) => setState(() => isOnHover = false),
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () => _filesystemController.selectedItems.clear(),
                                child: KeyValue(
                                  k: 'selected',
                                  v: '${_filesystemController.selectedItems.length}/${_filesystemController.filesystemTree.value!.childs!.length}',
                                  keyTextColor: Colors.white,
                                  valueTextColor: Colors.white,
                                  keyBackgroundColor: Colors.brown,
                                  valueBackgroundColor: Colors.pinkAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 2),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(border: Border.all(color: Colors.black12, width: 1)),
                      child: MouseRegion(
                        onHover: (e) => setState(() {
                          dx = e.position.dx;
                          dy = e.position.dy;
                        }),
                        child: GestureDetector(
                          onTap: () {
                            deselectAllItems();
                          },
                          onSecondaryTap: () {
                            showContextMenu(Offset(dx, dy), context, (builder) => getContextMenu(), 0, 170);
                          },
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
                                contextMenuItems: [
                                  if (!isItemOnAction(child.fullPath)) ListTile(title: Text('Copy', style: TextStyle(fontSize: 14)), leading: Icon(Icons.copy, size: 18), onTap: () => {setCopyItems(), Get.back()}),
                                  if (!isItemOnAction(child.fullPath)) ListTile(title: Text('Cut', style: TextStyle(fontSize: 14)), leading: Icon(Icons.cut, size: 18), onTap: () => {setCutItems(), Get.back()}),
                                  ListTile(title: Text('Delete', style: TextStyle(fontSize: 14)), leading: Icon(MdiIcons.trashCanOutline, size: 18), onTap: () => deleteConfirmationDialog()),
                                ],
                                isSelected: isSelected(child.fullPath),
                                filesystemTree: child,
                                iconColor: isItemOnAction(child.fullPath) ? Colors.grey : Colors.blueGrey,
                                onDoubleClick: child.isFile ? null : () => enterFolder(child.fullPath),
                                onSelect: () => selectItem(child.fullPath),
                                onDeselect: () => deselectItem(child.fullPath),
                              );
                            },
                          ),
                        ),
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

  Future<void> deleteItems() async {
    deleteConfirmationDialog();
  }

  void selectAllItems() {
    _filesystemController.selectedItems.clear();
    _filesystemController.selectedItems.addAll(_filesystemController.filesystemTree.value!.childs!.map((e) => e.fullPath).toList());
  }

  void setCopyItems() {
    _filesystemController.cuteItems.clear();
    _filesystemController.copyItems.clear();
    _filesystemController.copyItems.addAll(_filesystemController.selectedItems);
    _filesystemController.selectedItems.clear();
  }

  bool isItemOnAction(String fullPath) {
    if (_filesystemController.copyItems.contains(fullPath)) return true;
    if (_filesystemController.cuteItems.contains(fullPath)) return true;
    return false;
  }

  bool isAnyItemOnAction() {
    if (_filesystemController.copyItems.isNotEmpty) return true;
    if (_filesystemController.cuteItems.isNotEmpty) return true;
    return false;
  }

  void setCutItems() {
    _filesystemController.copyItems.clear();
    _filesystemController.cuteItems.clear();
    _filesystemController.cuteItems.addAll(_filesystemController.selectedItems);
    _filesystemController.selectedItems.clear();
  }

  void deselectAllItems() => _filesystemController.selectedItems.isEmpty ? () : _filesystemController.selectedItems.clear();

  bool hasDirectoryPath() => _filesystemController.directoryPath.isNotEmpty;

  void selectItem(String fullPath) {
    if (!_filesystemController.selectedItems.contains(fullPath)) {
      _filesystemController.selectedItems.add(fullPath);
    }
  }

  void deselectItem(String fullPath) => _filesystemController.selectedItems.remove(fullPath);

  bool isSelected(String fullPath) => _filesystemController.selectedItems.contains(fullPath);

  bool isAnySelected() => _filesystemController.selectedItems.isNotEmpty;

  void enterFolder(String fullPath) {
    _filesystemController.directoryPath.value = fullPath;
    _filesystemController.fetchFilesystemTree();
    _filesystemController.selectedItems.clear();
  }

  List<Widget> getContextMenu() {
    return [
      if (isAnyItemOnAction()) ListTile(title: Text('Paste', style: TextStyle(fontSize: 14)), leading: Icon(Icons.paste, size: 18), onTap: () => {displayEvent(), _filesystemController.paste(), Get.back()}),
      ListTile(title: Text('New Folder', style: TextStyle(fontSize: 14)), leading: Icon(Icons.create_new_folder, size: 18), onTap: () => addFolderDialog()),
    ];
  }

  @override
  void dispose() {
    _filesystemController.clear();
    super.dispose();
  }
}
