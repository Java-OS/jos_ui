class Module {
  final String name;
  final String version;
  final String description;
  final bool enable;
  final bool started;
  final List<String> dependencies;
  final String fullName;
  final bool lock;
  final bool service;

  Module({required this.name, required this.version, required this.description, required this.enable, required this.started, required this.dependencies, required this.fullName, required this.lock, required this.service});

  factory Module.fromMap(Map<String, dynamic> json) {
    var deps = (json['dependencies'] as List).map((e) => e.toString()).toList();
    return Module(
      name: json['name'],
      version: json['version'],
      description: json['description'],
      enable: json['enable'],
      started: json['started'],
      dependencies: deps,
      fullName: json['fullName'],
      lock: json['lock'],
      service: json['service'],
    );
  }
}
