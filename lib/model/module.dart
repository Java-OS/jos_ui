import 'package:jos_ui/model/module_dependency.dart';

class Module {
  final String name;
  final bool started;
  final String path;
  final String? description;
  final String? maintainer;
  final String? url;
  final List<ModuleDependency> dependencies;

  Module({required this.name, required this.started, required this.path, required this.description, required this.maintainer, required this.url, required this.dependencies});

  factory Module.fromMap(Map<String, dynamic> json) {
    var deps = (json['dependencies'] as List).map((e) => ModuleDependency.fromMap(e)).toList();
    return Module(
      name: json['name'],
      started: json['started'],
      path: json['path'],
      description: json['description'] ?? '',
      maintainer: json['maintainer'] ?? '',
      url: json['url'] ?? '',
      dependencies: deps,
    );
  }
}
