import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/toast.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/model/container/container.dart';
import 'package:jos_ui/model/container/container_image.dart';
import 'package:jos_ui/model/container/container_info.dart';
import 'package:jos_ui/model/container/image_search.dart';
import 'package:jos_ui/model/container/network.dart';
import 'package:jos_ui/model/container/network_connect.dart';
import 'package:jos_ui/model/container/network_info.dart';
import 'package:jos_ui/model/container/port_mapping.dart';
import 'package:jos_ui/model/container/subnet.dart';
import 'package:jos_ui/model/container/volume.dart';
import 'package:jos_ui/model/container/volume_parameter.dart';
import 'package:jos_ui/model/firewall/protocol.dart';
import 'package:jos_ui/service/api_service.dart';

class OciController extends GetxController {
  final _apiService = Get.put(ApiService());
  final TextEditingController searchImageEditingController = TextEditingController();
  final TextEditingController volumeNameEditingController = TextEditingController();
  final TextEditingController volumeMountPointEditingController = TextEditingController();

  /* Network fields */
  final TextEditingController networkNameEditingController = TextEditingController();
  final TextEditingController networkSubnetEditingController = TextEditingController();
  final TextEditingController networkGatewayEditingController = TextEditingController();

  /* Container fields */
  final TextEditingController containerNameEditingController = TextEditingController();
  final TextEditingController containerDnsSearchEditingController = TextEditingController();
  final TextEditingController containerDnsServerEditingController = TextEditingController();
  final TextEditingController containerUserEditingController = TextEditingController();
  final TextEditingController containerWorkDirEditingController = TextEditingController();
  final TextEditingController containerIpAddressEditingController = TextEditingController();
  final TextEditingController containerMacAddressEditingController = TextEditingController();
  final TextEditingController containerEnvironmentKeyEditingController = TextEditingController();
  final TextEditingController containerEnvironmentValueEditingController = TextEditingController();
  final TextEditingController containerPortEditingController = TextEditingController();
  final TextEditingController hostPortEditingController = TextEditingController();
  final TextEditingController hostIpEditingController = TextEditingController();
  final TextEditingController rangeEditingController = TextEditingController();

  /* Registries */
  final TextEditingController registryEditingController = TextEditingController();

  /* Exec Instance */
  final TextEditingController execEditingController = TextEditingController();

  var searchImageList = <ImageSearch>[].obs;
  var containerImageList = <ContainerImage>[].obs;
  var volumeList = <Volume>[].obs;
  var networkList = <NetworkInfo>[].obs;
  var containerList = <ContainerInfo>[].obs;
  var environments = <String, String>{}.obs;
  var useHostEnvironments = false.obs;
  var expose = <int, Protocol>{}.obs;
  var hosts = <String>[].obs;
  var privileged = false.obs;
  var connectVolumes = <VolumeParameter>[].obs;
  var portMappings = <PortMapping>[].obs;
  var selectedImage = ''.obs;
  var networkConnect = <String, NetworkConnect>{}.obs;
  var selectedNetwork = Rxn<NetworkInfo>();
  var selectedProtocol = Protocol.tcp.obs;
  var step = 0.obs;
  var registries = <String>{}.obs;

  /* Image methods */
  Future<void> listImages() async {
    developer.log('List images');
    _apiService.callApi(Rpc.RPC_CONTAINER_IMAGE_LIST).then((e) => e as List).then((list) => containerImageList.value = list.map((e) => ContainerImage.fromMap(e)).toList());
  }

  Future<void> removeImage(String id) async {
    developer.log('remove image $id');
    var reqParams = {'name': id};
    _apiService.callApi(Rpc.RPC_CONTAINER_IMAGE_REMOVE, parameters: reqParams, message: 'Failed to remove image $id').then((e) => listImages());
  }

  Future<void> searchImage() async {
    searchImageList.clear();
    var name = searchImageEditingController.text;
    var reqParams = {'name': name};

    developer.log('Search image $name');

    _apiService.callApi(Rpc.RPC_CONTAINER_IMAGE_SEARCH, parameters: reqParams).then((e) => e as List).then((list) => searchImageList.value = list.map((e) => ImageSearch.fromMap(e)).toList());
  }

  void pullImage(String name) async {
    // ociSSEConsumer(null, EventCode.NOTIFICATION);
    developer.log('Pull image $name');
    var reqParams = {'name': name};
    searchImageList.removeWhere((item) => item.name == name);
    _apiService.callApi(Rpc.RPC_CONTAINER_IMAGE_PULL, parameters: reqParams).then((e) => ContainerImage('', '', 0, 0, name, '')).then((e) => containerImageList.add(e));
  }

  void cancelPullImage(String name) async {
    developer.log('Cancel pull image $name');
    var reqParams = {'name': name};
    _apiService.callApi(Rpc.RPC_CONTAINER_IMAGE_PULL_CANCEL, parameters: reqParams).then((e) {
      var indexIndex = searchImageList.indexWhere((item) => item.name == name);
      if (indexIndex >= 0) {
        var updatableItem = searchImageList[indexIndex];
        updatableItem.tag = '';
        searchImageList[indexIndex] = updatableItem;
      }
      containerImageList.removeWhere((item) => item.name == name);
    });
  }

  /* Volume methods */
  Future<void> listVolumes() async {
    developer.log('List volumes');
    _apiService.callApi(Rpc.RPC_CONTAINER_VOLUME_LIST).then((e) => e as List).then((list) => volumeList.value = list.map((e) => Volume.fromMap(e)).toList());
  }

  void createVolume() async {
    var name = volumeNameEditingController.text;
    developer.log('Create volume $name');
    var reqParams = {'name': name};
    _apiService.callApi(Rpc.RPC_CONTAINER_VOLUME_CREATE, parameters: reqParams).then((e) => listVolumes().then((_) => Get.back()).then((_) => clean()));
  }

  Future<void> removeVolume(String name) async {
    developer.log('Remove volume $name');
    var reqParams = {'name': name};
    _apiService.callApi(Rpc.RPC_CONTAINER_VOLUME_REMOVE, parameters: reqParams).then((e) => listVolumes());
  }

  Future<void> pruneVolume() async {
    developer.log('Prune volume');
    _apiService.callApi(Rpc.RPC_CONTAINER_VOLUME_PRUNE).then((e) => listVolumes());
  }

  /* Network methods */
  Future<void> listNetworks() async {
    developer.log('List networks');
    _apiService.callApi(Rpc.RPC_CONTAINER_NETWORK_LIST).then((e) => e as List).then((list) => networkList.value = list.map((e) => NetworkInfo.fromMap(e)).toList());
  }

  void createNetwork() async {
    var name = networkNameEditingController.text;
    var subnet = networkSubnetEditingController.text;
    var gateway = networkGatewayEditingController.text;
    developer.log('Create network $name');

    var subnets = subnet.isEmpty ? <Subnet>[] : [Subnet(subnet, gateway)];
    var network = Network(name, subnets);
    var networkJson = jsonEncode(network.toMap());

    var reqParams = {'network': networkJson};
    _apiService.callApi(Rpc.RPC_CONTAINER_NETWORK_CREATE, parameters: reqParams).then((e) => listNetworks().then((_) => Get.back()).then((_) async => await listNetworks()));
  }

  void removeNetwork(String name) async {
    developer.log('Remove network $name');
    var reqParams = {'name': name};
    _apiService.callApi(Rpc.RPC_CONTAINER_NETWORK_REMOVE, parameters: reqParams).then((e) => listNetworks());
  }

  /* Container methods */
  Future<void> listContainers() async {
    developer.log('List containers');
    _apiService.callApi(Rpc.RPC_CONTAINER_LIST).then((e) => e as List).then((list) => containerList.value = list.map((e) => ContainerInfo.fromMap(e)).toList());
  }

  Future<void> killContainer(String name) async {
    developer.log('kill containers $name');
    var reqParams = {'name': name};
    _apiService.callApi(Rpc.RPC_CONTAINER_KILL, parameters: reqParams, message: 'Failed to kill container $name').then((e) => listContainers());
  }

  Future<void> stopContainer(String name) async {
    developer.log('stop containers $name');
    var reqParams = {'name': name};
    _apiService.callApi(Rpc.RPC_CONTAINER_STOP, parameters: reqParams, message: 'Failed to stop container $name').then((e) => listContainers());
  }

  Future<void> removeContainer(String name, String id) async {
    developer.log('remove containers $name');
    var reqParams = {
      'id': id,
      'name': name,
    };
    _apiService.callApi(Rpc.RPC_CONTAINER_REMOVE, parameters: reqParams, message: 'Failed to remove container $name').then((e) => listContainers());
  }

  Future<void> pruneContainer() async {
    developer.log('prune containers');
    _apiService.callApi(Rpc.RPC_CONTAINER_PRUNE, message: 'Failed to prune container').then((e) => listContainers());
  }

  Future<void> startContainer(String name) async {
    developer.log('Start containers $name');
    var reqParams = {'name': name};
    _apiService.callApi(Rpc.RPC_CONTAINER_START, parameters: reqParams, message: 'Failed to kill container $name').then((e) => listContainers());
  }

  void createContainer() async {
    // ociSSEConsumer(null, EventCode.NOTIFICATION);
    developer.log('Try to create container');
    var name = containerNameEditingController.text;
    var dnsSearch = containerDnsSearchEditingController.text;
    var dnsServer = containerDnsServerEditingController.text;
    var user = containerUserEditingController.text;
    var workDir = containerWorkDirEditingController.text;
    developer.log('Create container $name');

    var netns = selectedNetwork.value != null ? {'nsmode': selectedNetwork.value!.driver} : null;

    var container = CreateContainer(
      name,
      dnsSearch.isEmpty ? null : [dnsSearch],
      dnsServer.isEmpty ? null : dnsServer.split(','),
      environments.isEmpty ? null : environments,
      useHostEnvironments.value,
      expose.isEmpty ? null : expose,
      hosts.isEmpty ? null : hosts,
      selectedImage.value,
      null,
      privileged.value,
      user.isEmpty ? null : user,
      workDir.isEmpty ? null : workDir,
      connectVolumes.isEmpty ? null : connectVolumes,
      portMappings.isEmpty ? null : portMappings,
      networkConnect.isEmpty ? null : networkConnect,
      netns,
    );

    var json = jsonEncode(container.toMap());

    var reqParams = {'container': json};
    _apiService.callApi(Rpc.RPC_CONTAINER_CREATE, parameters: reqParams).then((_) => Get.back()).then((_) => listContainers()).then((_) => cleanContainerParameters());
  }

  /* Other methods */
  bool isImageInstalled(String name) {
    return containerImageList.map((e) => e.name).contains(name);
  }

  void applyVolumeToContainer() {
    var dest = volumeMountPointEditingController.text;
    var name = volumeNameEditingController.text;
    var exists = connectVolumes.any((e) => e.dest == dest);
    if (exists) {
      displayWarning('Duplicate mount point');
      return;
    }
    var volume = VolumeParameter(dest.startsWith('/') ? dest : '/$dest', name, null);
    connectVolumes.add(volume);
    Get.back();
    volumeMountPointEditingController.clear();
  }

  void applyNetworkToContainer() {
    var ip = containerIpAddressEditingController.text;
    var mac = containerMacAddressEditingController.text;
    var networkName = selectedNetwork.value!.name;

    var nc = NetworkConnect(ip.isEmpty ? null : [ip], mac.isEmpty ? null : mac, null);
    networkConnect[networkName] = nc;
    Get.back();
  }

  void addEnvironment() {
    var key = containerEnvironmentKeyEditingController.text;
    var value = containerEnvironmentValueEditingController.text;
    environments[key] = value;
    Get.back();
  }

  void removeEnvironment(String key) {
    environments.removeWhere((k, v) => k == key);
  }

  void updateEnvironment() {
    var key = containerEnvironmentKeyEditingController.text;
    var value = containerEnvironmentValueEditingController.text;
    environments[key] = value;
    Get.back();
  }

  void addExposePort() {
    var port = int.parse(containerPortEditingController.text);
    expose[port] = selectedProtocol.value;
    clearPortParameters();
    Get.back();
  }

  void removeExposePort(int port) {
    expose.removeWhere((k, v) => k == port);
  }

  void addPublishPort() {
    var hostPort = int.parse(hostPortEditingController.text);
    var hostIp = hostIpEditingController.text.isEmpty ? null : hostIpEditingController.text;
    var containerPort = int.parse(containerPortEditingController.text);
    var range = rangeEditingController.text.isEmpty ? null : int.parse(rangeEditingController.text);
    var protocol = selectedProtocol.value;
    var pm = PortMapping(containerPort, hostIp, hostPort, protocol, range);
    portMappings.add(pm);

    // clear
    clearPortParameters();
    Get.back();
  }

  void removePublishPort(int index) {
    portMappings.removeAt(index);
  }

  void changeProtocol(Protocol p) {
    selectedProtocol.value = p;
  }

  Future<void> loadRegistries() async {
    developer.log('Load registries');
    _apiService.callApi(Rpc.RPC_CONTAINER_SETTING_REGISTRIES_LOAD).then((e) => registries.assignAll(Set<String>.from(e)));
  }

  Future<void> saveRegistries() async {
    developer.log('Save registries');
    var reqParams = {'registries': jsonEncode(registries.toList())};
    developer.log('$registries');
    _apiService.callApi(Rpc.RPC_CONTAINER_SETTING_REGISTRIES_SAVE, parameters: reqParams).then((e) => loadRegistries()).then((e) => Get.back()).then((e) => clean());
  }

  Future<void> removeRegistries(String registry) async {
    developer.log('Remove registries');
    registries.removeWhere((e) => e == registry);
    var reqParams = {'registries': jsonEncode(registries.toList())};
    _apiService.callApi(Rpc.RPC_CONTAINER_SETTING_REGISTRIES_SAVE, parameters: reqParams).then((e) => loadRegistries());
  }

  Future<String> createExecInstance(String containerId) async {
    developer.log('Create exec instance');
    var reqParams = {
      'containerId': containerId,
      'cmd': execEditingController.text,
    };
    var result = await _apiService.callApi(Rpc.RPC_CONTAINER_CREATE_EXEC_INSTANCE, parameters: reqParams, disableLoading: true);
    return result['Id'];
  }

  Future<void> createResizeTTY(String execId, int h, int w) async {
    developer.log('Resize TTY to $h x $w');
    var reqParams = {
      'execId': execId,
      'h': h,
      'w': w,
    };
    await _apiService.callApi(Rpc.RPC_CONTAINER_RESIZE_TTY, parameters: reqParams);
  }

  /* Other methods */
  void clearNetworkParameters() {
    containerIpAddressEditingController.clear();
    containerMacAddressEditingController.clear();
    networkSubnetEditingController.clear();
    networkGatewayEditingController.clear();
    selectedNetwork = Rxn<NetworkInfo>();
  }

  void clearPortParameters() {
    hostPortEditingController.clear();
    hostIpEditingController.clear();
    containerPortEditingController.clear();
    rangeEditingController.clear();
  }

  void cleanContainerParameters() {
    containerNameEditingController.clear();
    containerDnsSearchEditingController.clear();
    containerDnsServerEditingController.clear();
    containerUserEditingController.clear();
    containerWorkDirEditingController.clear();
    containerIpAddressEditingController.clear();
    containerMacAddressEditingController.clear();
    containerEnvironmentKeyEditingController.clear();
    containerEnvironmentValueEditingController.clear();
    registryEditingController.clear();
    environments.clear();
    connectVolumes.clear();
    portMappings.clear();
    networkConnect.clear();
    expose.clear();
    selectedNetwork = Rxn<NetworkInfo>();
    selectedImage.value = '';
    step.value = 0;
    privileged.value = false;
  }

  void clean() {
    searchImageList.clear();
    searchImageEditingController.clear();
    volumeNameEditingController.clear();
  }
}
