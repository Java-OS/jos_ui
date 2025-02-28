import 'package:contextmenu_plus/contextmenu_plus.dart';
import 'package:flutter/material.dart';
import 'package:jos_ui/model/filesystem_tree.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
        showContextMenu(Offset(dx, dy), context, (builder) => widget.contextMenuItems!, 0, 200);
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
                    getIcon(widget.filesystemTree),
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

  IconData getIcon(FilesystemTree fst) {
    var mime = fst.mime;
    switch (mime) {
      case 'inode/directory':
        return Icons.folder;
      case 'text/plain':
      case 'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
      case 'application/vnd.oasis.opendocument.text':
        return Icons.text_snippet_outlined;
      case 'application/pdf':
        return MdiIcons.filePdfBox;
      case 'audio/mpeg':
      case 'audio/x-wav':
        return Icons.audio_file_outlined;
      case 'video/mp4':
      case 'video/quicktime':
      case 'video/x-cdxa':
      case 'video/x-flv':
      case 'video/x-matroska':
        return Icons.video_file_outlined;
      case 'inode/chardevice':
        return MdiIcons.devices;
      case 'inode/symlink':
        return fst.isFile ? MdiIcons.fileLinkOutline : MdiIcons.folderOutline;
      case 'inode/blockdevice':
        return MdiIcons.harddisk;
      case 'inode/fifo':
        return Icons.route;
      case 'application/x-tar':
      case 'application/x-bzip2':
      case 'application/gzip':
      case 'application/x-xz':
      case 'application/zip':
      case 'application/java-archive':
        return MdiIcons.archiveOutline;
      case 'application/x-pie-executable':
      case 'application/x-executable':
      case 'application/x-sharedlib':
      case 'text/x-shellscript':
      case 'text/x-script.python':
        return MdiIcons.applicationOutline;
      case 'text/html':
        return Icons.html_outlined;
      default :
        return MdiIcons.fileOutline;
    }
  }
}
