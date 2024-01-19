class Module {
  final String name;
  final String version;
  final String description;
  final bool enable;
  final bool activeService;
  final List<String> dependencies;
  final String fullName;
  final bool lock;
  final bool containService;

  Module({required this.name, required this.version, required this.description, required this.enable, required this.activeService, required this.dependencies, required this.fullName, required this.lock, required this.containService});

  factory Module.fromJson(Map<String, dynamic> json) {
    var deps = (json['dependencies'] as List).map((e) => e.toString()).toList();
    return Module(
      name: json['name'],
      version: json['version'],
      description: json['description'],
      enable: json['enable'],
      activeService: json['activeService'],
      dependencies: deps,
      fullName: json['fullName'],
      lock: json['lock'],
      containService: json['containService'],
    );
  }
}
