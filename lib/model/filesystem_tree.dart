import 'dart:convert';

class FilesystemTree {
  final String name;
  final String fullPath;
  final List<FilesystemTree>? childs;
  final bool isFile;
  final String mime;

  FilesystemTree({required this.name, required this.fullPath, this.childs = const <FilesystemTree>[], required this.isFile, required this.mime});

  factory FilesystemTree.fromMap(Map<String, dynamic> map) {
    var name = map['name'];
    var fullPath = map['fullPath'];
    var isFile = map['file'];
    var childs = (map['childs'] == null)
        ? []
        : (map['childs'] == null && !isFile)
            ? []
            : map['childs'] as List;
    var mappedChilds = childs.map((e) => FilesystemTree.fromMap(e)).toList();
    var mime = map['mime'];
    return FilesystemTree(name: name, fullPath: fullPath, childs: mappedChilds, isFile: isFile, mime: mime);
  }

  String toJson() {
    return jsonEncode(this);
  }
}
