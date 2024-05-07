class VolumeParameter {
  final String dest;
  final String name;
  final String? options;

  VolumeParameter(this.dest, this.name, this.options);

  factory VolumeParameter.fromMap(Map<String, dynamic> map) {
    var dest = map['Dest'];
    var name = map['Name'];
    var options = map['Options'] ?? '';

    return VolumeParameter(dest, name, options);
  }

  Map<String, dynamic> toMap() {
    return {
      'dest': dest,
      'name': name,
      'options': options,
    };
  }
}
