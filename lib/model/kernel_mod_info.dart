class KernelModInfo {
  final String name;
  final int size;
  final int usedBy;
  final String usedByModules;

  KernelModInfo({required this.name, required this.size, required this.usedBy, required this.usedByModules});

  factory KernelModInfo.fromMap(Map<String, dynamic> json) {
    var name = json['name'];
    var size = json['size'] as int;
    var usedBy = json['usedBy'] as int;
    var usedByModules = json['usedByModules'];

    return KernelModInfo(name: name, size: size, usedBy: usedBy, usedByModules: usedByModules);
  }
}
