import 'package:jos_ui/model/container/network_connect.dart';
import 'package:jos_ui/model/container/port_mapping.dart';
import 'package:jos_ui/model/firewall/protocol.dart';
import 'package:jos_ui/model/container/volume_parameter.dart';

class CreateContainer {
  final String? name;
  final List<String>? dnsSearch;
  final List<String>? dnsServer;
  final Map<String, String>? environments;
  final bool useHostEnvironments;
  final Map<int, Protocol>? expose;
  final List<String>? hosts;
  final String image;
  final String? pod;
  final bool privileged;
  final String? user;
  final String? workDir;
  final List<VolumeParameter>? volumes;
  final List<PortMapping>? portMappings;
  final Map<String, NetworkConnect>? networks;
  final Map<String, String>? netns;

  CreateContainer(this.name, this.dnsSearch, this.dnsServer, this.environments, this.useHostEnvironments, this.expose, this.hosts, this.image, this.pod, this.privileged, this.user, this.workDir, this.volumes, this.portMappings, this.networks, this.netns);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dns_search': dnsSearch,
      'dns_server': dnsServer,
      'env': environments,
      'env_host': useHostEnvironments,
      'expose': expose?.map((k,v) => MapEntry(k.toString(), v.name.toUpperCase())),
      'hostadd': hosts,
      'image': image,
      'pod': pod,
      'privileged': privileged,
      'user': user,
      'work_dir': workDir,
      'volumes': volumes?.map((e) => e.toMap()).toList(),
      'portmappings': portMappings?.map((e) => e.toMap()).toList(),
      'Networks': networks?.map((k,v) => MapEntry(k, v.toMap())),
      'netns': netns,
    };
  }
}
