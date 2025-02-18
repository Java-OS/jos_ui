import 'package:flutter/material.dart';
import 'package:jos_ui/model/filesystem_tree.dart';

class FileView extends StatefulWidget {
  final FilesystemTree filesystemTree;
  final Function? onDoubleClick;
  final Function? onSelect;
  final Function? onDeselect;
  final bool isSelected;

  const FileView({
    super.key,
    required this.filesystemTree,
    this.onSelect,
    this.onDeselect,
    this.onDoubleClick,
    this.isSelected = false,
  });

  @override
  State<FileView> createState() => _FileViewState();
}

class _FileViewState extends State<FileView> {
  bool onHover = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onSelect != null && !widget.isSelected) widget.onSelect!();
        if (widget.onDeselect != null && widget.isSelected) widget.onDeselect!();
      },
      onDoubleTap: widget.onDoubleClick != null ? () => widget.onDoubleClick!() : null,
      child: Column(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onHover: (e) => setState(() => onHover = true),
            onExit: (e) => setState(() => onHover = false),
            child: AnimatedContainer(
              padding: EdgeInsets.all(20),
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: onHover
                    ? Color.fromARGB(50, 171, 190, 204)
                    : widget.isSelected
                        ? Color.fromARGB(120, 171, 190, 204)
                        : null,
                border: Border.all(
                  color: (onHover || widget.isSelected) ? Colors.grey : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    widget.filesystemTree.isFile ? Icons.insert_drive_file_outlined : Icons.folder,
                    color: Colors.blueGrey,
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
}
