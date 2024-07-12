class PartitionInformation {
  final String blk;
  final String mountPoint;
  final String uuid;
  final String? label;
  final String type;
  final int totalSize;
  final int? freeSize;
  final int startSector;
  final int endSector;
  final int sectorSize;

  PartitionInformation(this.blk, this.mountPoint, this.totalSize, this.freeSize, this.uuid, this.label, this.type, this.startSector, this.endSector, this.sectorSize);

  factory PartitionInformation.fromJson(Map<String, dynamic> map) {
    var blk = map['blk'];
    var mountPoint = map['mountPoint'];
    var uuid = map['uuid'];
    var label = map['label'];
    var type = map['type'];
    var total = map['totalSize'];
    var free = map['freeSize'];
    var startSector = map['startSector'];
    var endSector = map['endSector'];
    var sectorSize = map['sectorSize'];
    return PartitionInformation(blk, mountPoint, total, free, uuid, label, type, startSector, endSector, sectorSize);
  }
}
