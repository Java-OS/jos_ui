import 'package:flutter/cupertino.dart';

class FilesystemTree {
  final String name;
  final String fullPath;
  final List<FilesystemTree> childs;
  final bool isFile;

  FilesystemTree({required this.name, required this.fullPath, this.childs = const <FilesystemTree>[], required this.isFile});

  factory FilesystemTree.fromJson(Map<String, dynamic> map) {
    var name = map['name'];
    var fullPath = map['fullPath'];
    var childs = map['childs'] as List;
    var mappedChilds = childs.isNotEmpty ? childs.map((e) => FilesystemTree.fromJson(e)).toList() : <FilesystemTree>[];
    var isFile = map['isFile'];
    return FilesystemTree(name: name, fullPath: fullPath, childs: mappedChilds, isFile: isFile);
  }
}
