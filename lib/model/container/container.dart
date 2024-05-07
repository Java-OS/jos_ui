import 'package:jos_ui/model/container/network_connect.dart';
import 'package:jos_ui/model/container/port_mapping.dart';
import 'package:jos_ui/model/container/protocol.dart';
import 'package:jos_ui/model/container/volume_parameter.dart';

class CreateContainer {
  final String? name;
  final List<String>? dnsSearch;
  final List<String>? dnsServer;
  final Map<String, String>? environments;
  final bool useHostEnvironments;
  final Map<int, Protocol>? expose;
  final List<String>? hosts;
  final String? hostname;
  final String image;
  final String? pod;
  final bool privileged;
  final String? user;
  final String? workDir;
  final List<VolumeParameter>? volumes;
  final List<PortMapping>? portMappings;
  final Map<String, NetworkConnect>? networks;
  final Map<String, String>? netns;

  CreateContainer(this.name, this.dnsSearch, this.dnsServer, this.environments, this.useHostEnvironments, this.expose, this.hosts, this.hostname, this.image, this.pod, this.privileged, this.user, this.workDir, this.volumes, this.portMappings, this.networks, this.netns);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dnsSearch': dnsSearch,
      'dnsServer': dnsServer,
      'environments': environments,
      'useHostEnvironments': useHostEnvironments,
      'expose': expose,
      'hosts': hosts,
      'hostname': hostname,
      'image': image,
      'pod': pod,
      'privileged': privileged,
      'user': user,
      'workDir': workDir,
      'volumes': volumes,
      'portMappings': portMappings,
      'networks': networks,
      'netns': netns,
    };
  }
}
