import 'package:jos_ui/model/module_dependency.dart';

class Module {
  final String name;
  final bool started;
  final String path;
  final List<ModuleDependency> dependencies;

  Module({required this.name, required this.started, required this.path, required this.dependencies});

  factory Module.fromMap(Map<String, dynamic> json) {
    var deps = (json['dependencies'] as List).map((e) => ModuleDependency.fromMap(e)).toList();
    return Module(
      name: json['name'],
      started: json['started'],
      path: json['path'],
      dependencies: deps,
    );
  }
}
