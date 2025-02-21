import 'package:contextmenu_plus/contextmenu_plus.dart';
import 'package:flutter/material.dart';
import 'package:jos_ui/model/filesystem_tree.dart';

class FileView extends StatefulWidget {
  final FilesystemTree filesystemTree;
  final Function? onDoubleClick;
  final Function? onSelect;
  final Function? onDeselect;
  final bool isSelected;
  final Color iconColor;
  final List<Widget>? contextMenuItems;

  const FileView({
    super.key,
    required this.filesystemTree,
    this.onSelect,
    this.onDeselect,
    this.onDoubleClick,
    this.isSelected = false,
    this.iconColor = Colors.blueGrey,
    this.contextMenuItems,
  });

  @override
  State<FileView> createState() => _FileViewState();
}

class _FileViewState extends State<FileView> {
  bool onHover = false;
  double dx = 0;
  double dy = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTap: () {
        showContextMenu(Offset(dx, dy), context, (builder) => widget.contextMenuItems!, 0, 170);
        widget.onSelect!();
      },
      onTap: () {
        if (widget.onSelect != null && !widget.isSelected) widget.onSelect!();
        if (widget.onDeselect != null && widget.isSelected) widget.onDeselect!();
      },
      onDoubleTap: widget.onDoubleClick != null ? () => widget.onDoubleClick!() : null,
      child: Column(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onHover: (e) => setState(() {
              onHover = true;
              dx = e.position.dx;
              dy = e.position.dy;
            }),
            onExit: (e) => setState(() => onHover = false),
            child: AnimatedContainer(
              padding: EdgeInsets.all(20),
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: onHover && !widget.isSelected
                    ? Color.fromARGB(50, 201, 200, 200)
                    : widget.isSelected
                        ? Color.fromARGB(120, 171, 190, 204)
                        : null,
                border: Border.all(
                  color: (onHover || widget.isSelected) ? Colors.blue : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    widget.filesystemTree.isFile ? Icons.insert_drive_file_outlined : Icons.folder,
                    color: widget.iconColor,
                    size: 60,
                  ),
                  // SizedBox(height: 4),
                  Text(
                    widget.filesystemTree.name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

// ContextMenu getContextMenu() {
//   return ContextMenu(
//     padding: EdgeInsets.all(1),
//     borderRadius: BorderRadius.zero,
//     entries: widget.contextMenuItems ?? [],
//     position: Offset(dx, dy),
//   );
// }
}
