import 'dart:convert';

class FilesystemTree {
  final String name;
  final String fullPath;
  final List<FilesystemTree>? childs;
  final bool isFile;

  FilesystemTree({required this.name, required this.fullPath, this.childs = const <FilesystemTree>[], required this.isFile});

  factory FilesystemTree.fromJson(Map<String, dynamic> map) {
    var name = map['name'];
    var fullPath = map['fullPath'];
    var isFile = map['file'];
    var childs = (map['childs'] == null)
        ? []
        : (map['childs'] == null && !isFile)
            ? []
            : map['childs'] as List;
    var mappedChilds = childs.map((e) => FilesystemTree.fromJson(e)).toList();
    return FilesystemTree(name: name, fullPath: fullPath, childs: mappedChilds, isFile: isFile);
  }

  String toJson() {
    return jsonEncode(this);
  }
}
