class ModuleDependency {
  final String name;
  final String path;
  final List<String> modules;

  ModuleDependency({required this.name, required this.path, required this.modules});

  factory ModuleDependency.fromMap(Map<String, dynamic> json) {
    return ModuleDependency(
      name: json['name'],
      path: json['path'],
      modules: List<String>.from(json['modules']),
    );
  }
}
