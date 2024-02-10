class HDDPartition {
  final String partition;
  final String? mountPoint;
  final String uuid;
  final String? label;
  final String type;
  final int total;
  final int? free;

  HDDPartition(this.partition, this.mountPoint, this.total, this.free, this.uuid, this.label, this.type);

  factory HDDPartition.fromJson(Map<String, dynamic> map) {
    var partition = map['partition'];
    var mountPoint = map['mountPoint'];
    var uuid = map['uuid'];
    var label = map['label'];
    var type = map['type'];
    var total = map['total'];
    var free = map['free'];
    return HDDPartition(partition, mountPoint, total, free, uuid, label, type);
  }
}
