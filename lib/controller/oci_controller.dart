import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:fetch_client/fetch_client.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/model/container/container.dart';
import 'package:jos_ui/model/container/container_image.dart';
import 'package:jos_ui/model/container/container_info.dart';
import 'package:jos_ui/model/container/image_search.dart';
import 'package:jos_ui/model/container/network.dart';
import 'package:jos_ui/model/container/network_connect.dart';
import 'package:jos_ui/model/container/network_info.dart';
import 'package:jos_ui/model/container/port_mapping.dart';
import 'package:jos_ui/model/container/protocol.dart';
import 'package:jos_ui/model/container/subnet.dart';
import 'package:jos_ui/model/container/volume.dart';
import 'package:jos_ui/model/container/volume_parameter.dart';
import 'package:jos_ui/model/event.dart';
import 'package:jos_ui/model/event_code.dart';
import 'package:jos_ui/service/rest_client.dart';
import 'package:jos_ui/widget/toast.dart';

class OciController extends GetxController {
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

  var waitingImageSearch = false.obs;
  var waitingListImages = false.obs;

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
  var logs = ''.obs;

  FetchResponse? fetchResponse;
  late StreamSubscription<Event> sseListener;
  var sseConnected = false;

  Future<void> ociSSEConsumer(String? message, EventCode event) async {
    if (sseConnected) return;
    debugPrint('SSE Container Logs Consumer activated');
    sseConnected = true;
    var content = {
      'message': message,
      'code': event.value,
    };
    fetchResponse = await RestClient.sse(jsonEncode(content));
    sseListener = fetchResponse!.stream.where((event) => event.isNotEmpty).transform(const Utf8Decoder()).map((e) => Event.fromJson(e)).distinct().listen(
          (e) {
            var code = e.code;
            var message = e.message.trim();
            debugPrint('$code ->   $message');
            handleEvents(code, message);
          },
          cancelOnError: true,
          onError: (e) {
            debugPrint('$e');
            closeStreamListener();
          },
          onDone: () => closeStreamListener(),
        );
  }

  Future<void> handleEvents(EventCode code, String message) async {
    if (code == EventCode.ociImageNotification) {
      displayInfo(message);
      listImages();
    } else if (code == EventCode.ociContainerNotification) {
      displayInfo(message);
      listContainers();
    } else if (code == EventCode.ociContainerLogs) {
      if (logs.value.split('\n').length == 500) logs.value = logs.value.substring(logs.value.indexOf('\n') + 1);
      logs.value += '$message\n';
      logs.refresh();
    }
  }

  void closeStreamListener() {
    debugPrint('Close sse connection');
    sseListener.cancel();
    fetchResponse?.cancel();
    sseConnected = false;
    logs = ''.obs;
  }

  /* Image methods */
  Future<void> listImages() async {
    developer.log('List images');
    var payload = await RestClient.rpc(Rpc.RPC_CONTAINER_IMAGE_LIST);
    if (payload.metadata!.success) {
      var obj = (jsonDecode(payload.content!) as List);
      containerImageList.value = obj.map((e) => ContainerImage.fromMap(e)).toList();
    }
  }

  Future<void> removeImage(String id) async {
    developer.log('remove image $id');
    var reqParams = {'name': id};
    var payload = await RestClient.rpc(Rpc.RPC_CONTAINER_IMAGE_REMOVE, parameters: reqParams);
    if (!payload.metadata!.success) {
      displayWarning('Failed to remove image $id');
    }
    await listImages();
  }

  Future<void> searchImage() async {
    waitingImageSearch.value = true;
    searchImageList.clear();
    var name = searchImageEditingController.text;
    var reqParams = {'name': name};

    developer.log('Search image $name');

    var payload = await RestClient.rpc(Rpc.RPC_CONTAINER_IMAGE_SEARCH, parameters: reqParams);
    if (payload.metadata!.success) {
      var obj = (jsonDecode(payload.content!) as List);
      searchImageList.value = obj.map((e) => ImageSearch.fromMap(e)).toList();
    }
    waitingImageSearch.value = false;
  }

  void pullImage(String name) async {
    ociSSEConsumer(null, EventCode.ociImageNotification);
    developer.log('Pull image $name');
    var reqParams = {'name': name};
    searchImageList.removeWhere((item) => item.name == name);
    var payload = await RestClient.rpc(Rpc.RPC_CONTAINER_IMAGE_PULL, parameters: reqParams);
    if (payload.metadata!.success) {
      var pullItemImage = ContainerImage('', '', 0, 0, name, '');
      containerImageList.add(pullItemImage);
    }
  }

  void cancelPullImage(String name) async {
    developer.log('Cancel pull image $name');
    var reqParams = {'name': name};
    var payload = await RestClient.rpc(Rpc.RPC_CONTAINER_IMAGE_PULL_CANCEL, parameters: reqParams);
    if (payload.metadata!.success) {
      var indexIndex = searchImageList.indexWhere((item) => item.name == name);
      if (indexIndex >= 0) {
        var updatableItem = searchImageList[indexIndex];
        updatableItem.tag = '';
        searchImageList[indexIndex] = updatableItem;
      }

      containerImageList.removeWhere((item) => item.name == name);
    }
  }

  /* Volume methods */
  Future<void> listVolumes() async {
    developer.log('List volumes');
    var payload = await RestClient.rpc(Rpc.RPC_CONTAINER_VOLUME_LIST);
    if (payload.metadata!.success) {
      var obj = (jsonDecode(payload.content!) as List);
      volumeList.value = obj.map((e) => Volume.fromMap(e)).toList();
    }
  }

  void createVolume() async {
    var name = volumeNameEditingController.text;
    developer.log('Create volume $name');
    var reqParams = {'name': name};
    await RestClient.rpc(Rpc.RPC_CONTAINER_VOLUME_CREATE, parameters: reqParams);
    await listVolumes().then((_) => Get.back()).then((_) => clean());
  }

  Future<void> removeVolume(String name) async {
    developer.log('Remove volume $name');
    var reqParams = {'name': name};
    await RestClient.rpc(Rpc.RPC_CONTAINER_VOLUME_REMOVE, parameters: reqParams);
    await listVolumes();
  }

  Future<void> pruneVolume() async {
    developer.log('Prune volume');
    await RestClient.rpc(Rpc.RPC_CONTAINER_VOLUME_PRUNE);
    await listVolumes();
  }

  /* Network methods */
  Future<void> listNetworks() async {
    developer.log('List networks');
    var payload = await RestClient.rpc(Rpc.RPC_CONTAINER_NETWORK_LIST);
    if (payload.metadata!.success) {
      var obj = (jsonDecode(payload.content!) as List);
      networkList.value = obj.map((e) => NetworkInfo.fromMap(e)).toList();
    }
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
    await RestClient.rpc(Rpc.RPC_CONTAINER_NETWORK_CREATE, parameters: reqParams);
    await listNetworks().then((_) => Get.back()).then((_) async => await listNetworks());
  }

  void removeNetwork(String name) async {
    developer.log('Remove network $name');
    var reqParams = {'name': name};
    await RestClient.rpc(Rpc.RPC_CONTAINER_NETWORK_REMOVE, parameters: reqParams);
    await listNetworks();
  }

  /* Container methods */
  Future<void> listContainers() async {
    developer.log('List containers');
    var payload = await RestClient.rpc(Rpc.RPC_CONTAINER_LIST);
    if (payload.metadata!.success) {
      var obj = (jsonDecode(payload.content!) as List);
      containerList.value = obj.map((e) => ContainerInfo.fromMap(e)).toList();
    }
  }

  Future<void> killContainer(String name) async {
    developer.log('kill containers $name');
    var reqParams = {'name': name};
    var payload = await RestClient.rpc(Rpc.RPC_CONTAINER_KILL, parameters: reqParams);
    if (!payload.metadata!.success) {
      displayWarning('Failed to kill container $name');
    }
    await listContainers();
  }

  Future<void> stopContainer(String name) async {
    developer.log('stop containers $name');
    var reqParams = {'name': name};
    var payload = await RestClient.rpc(Rpc.RPC_CONTAINER_STOP, parameters: reqParams);
    if (!payload.metadata!.success) {
      displayWarning('Failed to stop container $name');
    }
    await listContainers();
  }

  Future<void> removeContainer(String name, String id) async {
    developer.log('remove containers $name');
    var reqParams = {
      'id': id,
      'name': name,
    };
    var payload = await RestClient.rpc(Rpc.RPC_CONTAINER_REMOVE, parameters: reqParams);
    if (!payload.metadata!.success) {
      displayWarning('Failed to remove container $name');
    }
    await listContainers();
  }

  Future<void> pruneContainer() async {
    developer.log('prune containers');
    var payload = await RestClient.rpc(Rpc.RPC_CONTAINER_PRUNE);
    if (!payload.metadata!.success) {
      displayWarning('Failed to prune container');
    }
    await listContainers();
  }

  Future<void> startContainer(String name) async {
    developer.log('Start containers $name');
    var reqParams = {'name': name};
    var payload = await RestClient.rpc(Rpc.RPC_CONTAINER_START, parameters: reqParams);
    if (!payload.metadata!.success) {
      displayWarning('Failed to kill container $name');
    }
    await listContainers();
  }

  void createContainer() async {
    ociSSEConsumer(null, EventCode.ociContainerNotification);
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
    await RestClient.rpc(Rpc.RPC_CONTAINER_CREATE, parameters: reqParams).then((_) => Get.back()).then((_) => listContainers()).then((_) => cleanContainerParameters());
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
    var payload = await RestClient.rpc(Rpc.RPC_CONTAINER_SETTING_REGISTRIES_LOAD);
    if (payload.metadata!.success) {
      registries.assignAll(Set<String>.from(jsonDecode(payload.content!)));
    }
  }

  Future<void> saveRegistries() async {
    developer.log('Save registries');
    var reqParams = {'registries': jsonEncode(registries.toList())};
    developer.log('$registries');
    await RestClient.rpc(Rpc.RPC_CONTAINER_SETTING_REGISTRIES_SAVE, parameters: reqParams);
    await loadRegistries();
    Get.back();
    registryEditingController.clear();
  }

  Future<void> removeRegistries(String registry) async {
    developer.log('Remove registries');
    registries.removeWhere((e) => e == registry);
    var reqParams = {'registries': jsonEncode(registries.toList())};
    developer.log('$registries');
    await RestClient.rpc(Rpc.RPC_CONTAINER_SETTING_REGISTRIES_SAVE, parameters: reqParams);
    await loadRegistries();
  }

  Future<void> uploadFileToVolume() async {
    var picked = await FilePicker.platform.pickFiles();
    if (picked != null) {
      var uploaded = await RestClient.upload(picked.files.single.bytes!, picked.files.single.name, UploadType.UPLOAD_TYPE_MODULE, null);
      if (uploaded) ();
    }
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

  @override
  void onClose() {
    closeStreamListener();
    super.onClose();
  }
}
