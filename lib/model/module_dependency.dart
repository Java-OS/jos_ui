class ModuleDependency {
  final String name;
  final String path;

  ModuleDependency({required this.name, required this.path});

  factory ModuleDependency.fromMap(Map<String, dynamic> json) {
    return ModuleDependency(
      name: json['name'],
      path: json['path'],
    );
  }
}
