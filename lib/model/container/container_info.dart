import 'package:jos_ui/model/container/port.dart';

class ContainerInfo {
  final bool autoRemove;
  final List<String> command;
  final bool exited;
  final int exitedAt;
  final int exitCode;
  final String id;
  final String image;
  final String imageID;
  final bool isInfra;
  final List<String> mounts;
  final List<String> names;
  final List<String> networks;
  final int pid;
  final String pod;
  final String podName;
  final List<Port> ports;
  final String size;
  final int startedAt;
  final String state;
  final String status;

  ContainerInfo(this.autoRemove, this.command, this.exited, this.exitedAt, this.exitCode, this.id, this.image, this.imageID, this.isInfra, this.mounts, this.names, this.networks, this.pid, this.pod, this.podName, this.ports, this.size, this.startedAt, this.state, this.status);

  factory ContainerInfo.fromMap(Map<String, dynamic> map) {
    var autoRemove = map['AutoRemove'] ?? false;
    var command = List<String>.from(map['Command'] ?? []);
    var exited = map['Exited'] ?? false;
    var exitedAt = map['ExitedAt'] ?? -1;
    var exitCode = map['ExitCode'] ?? -1 ;
    var id = map['Id'] ?? '';
    var image = map['Image'] ?? '';
    var imageID = map['ImageID'] ?? '';
    var isInfra = map['IsInfra'] ?? false;
    var mounts = List<String>.from(map['Mounts'] ?? []);
    var names = List<String>.from(map['Names'] ?? []);
    var networks = List<String>.from(map['Networks'] ?? []);
    var pid = map['Pid'] ?? -1;
    var pod = map['Pod'] ?? '';
    var podName = map['PodName'] ?? '';
    var ports = ((map['Ports'] ?? []) as List).map((item) => Port.fromMap(item)).toList();
    var size = map['Size'] ?? '';
    var startedAt = map['StartedAt'] ?? -1;
    var state = map['State'] ?? '';
    var status = map['Status'] ?? '';

    return ContainerInfo(autoRemove, command, exited, exitedAt, exitCode, id, image, imageID, isInfra, mounts, names, networks, pid, pod, podName, ports, size, startedAt, state, status);
  }
}
