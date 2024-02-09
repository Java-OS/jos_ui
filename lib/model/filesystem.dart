import 'package:flutter/cupertino.dart';

class HDDPartition {
  final String partition;
  final String? mountPoint;
  final int total;
  final int? free;

  HDDPartition(this.partition, this.mountPoint, this.total, this.free);

  factory HDDPartition.fromJson(Map<String, dynamic> map) {
    var total = map['total'];
    var free = map['free'];
    return HDDPartition(map['partition'], map['mountPoint'], total, free);
  }
}
