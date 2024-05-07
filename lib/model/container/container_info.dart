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
    var autoRemove = map['AutoRemove'];
    var command = (map['Command'] as List).map((e) => e.toString()).toList();
    var exited = map['Exited'];
    var exitedAt = map['ExitedAt'];
    var exitCode = map['ExitCode'];
    var id = map['Id'];
    var image = map['Image'];
    var imageID = map['ImageID'];
    var isInfra = map['IsInfra'];
    var mounts = (map['Mounts'] as List).map((e) => e.toString()).toList();
    var names = (map['Names'] as List).map((e) => e.toString()).toList();
    var networks = (map['Networks'] as List).map((e) => e.toString()).toList();
    var pid = map['Pid'];
    var pod = map['Pod'] ?? '';
    var podName = map['PodName'] ?? '';
    var ports = ((map['Ports'] ?? []) as List).map((item) => Port.fromMap(item)).toList();
    var size = map['Size'] ?? '';
    var startedAt = map['StartedAt'];
    var state = map['State'];
    var status = map['Status'] ?? '';

    return ContainerInfo(autoRemove, command, exited, exitedAt, exitCode, id, image, imageID, isInfra, mounts, names, networks, pid, pod, podName, ports, size, startedAt, state, status);
  }
}
