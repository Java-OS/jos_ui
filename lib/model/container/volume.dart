class Volume {
  final String? name;
  final String driver;
  final String mountPoint;
  final String createdAt;
  final Map<String, String> labels;
  final String scope;
  final int mountCount;
  final int lockNumber;

  Volume(this.name, this.driver, this.mountPoint, this.createdAt, this.labels, this.scope, this.mountCount, this.lockNumber);

  factory Volume.fromMap(Map<String, dynamic> map) {
    var name = map['Name'] ?? '';
    var driver = map['Driver'];
    var mountPoint = map['Mountpoint'];
    var createdAt = map['CreatedAt'];
    var labels = Map<String, String>.from(map['Labels']);
    var scope = map['Scope'];
    var mountCount = map['MountCount'];
    var lockNumber = map['LockNumber'];

    return Volume(name, driver, mountPoint, createdAt, labels, scope, mountCount, lockNumber);
  }
}
