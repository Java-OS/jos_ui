import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/model/container/ContainerImage.dart';
import 'package:jos_ui/model/container/container.dart';
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
import 'package:jos_ui/protobuf/message-buffer.pb.dart';
import 'package:jos_ui/service/rest_client.dart';
import 'package:jos_ui/widget/toast.dart';

class ContainerController extends GetxController {
  final TextEditingController searchImageEditingController = TextEditingController();
  final TextEditingController volumeNameEditingController = TextEditingController();
  final TextEditingController volumeMountPointEditingController = TextEditingController();

  /* Network fields */
  final TextEditingController networkNameEditingController = TextEditingController();
  final TextEditingController networkSubnetEditingController = TextEditingController();
  final TextEditingController networkGatewayEditingController = TextEditingController();

  /* Container fields */
  final TextEditingController containerNameEditingController = TextEditingController();
  final TextEditingController containerHostnameEditingController = TextEditingController();
  final TextEditingController containerDnsSearchEditingController = TextEditingController();
  final TextEditingController containerDnsServerEditingController = TextEditingController();
  final TextEditingController containerUserEditingController = TextEditingController();
  final TextEditingController containerWorkDirEditingController = TextEditingController();
  final TextEditingController containerIpAddressEditingController = TextEditingController();
  final TextEditingController containerMacAddressEditingController = TextEditingController();

  var searchImageList = <ImageSearch>[].obs;
  var containerImageList = <ContainerImage>[].obs;
  var volumeList = <Volume>[].obs;
  var networkList = <NetworkInfo>[].obs;
  var containerList = <ContainerInfo>[].obs;
  var waitingImageSearch = false.obs;
  var waitingImageRemove = false.obs;
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

  /* Image methods */
  Future<void> listImages() async {
    developer.log('List images');
    var payload = await RestClient.rpc(RPC.RPC_CONTAINER_IMAGE_LIST);
    if (payload.metadata.success) {
      var obj = (jsonDecode(payload.postJson) as List);
      containerImageList.value = obj.map((e) => ContainerImage.fromMap(e)).toList();
    }
  }

  Future<void> removeImage(String id) async {
    developer.log('remove image $id');
    waitingImageRemove.value = true;
    var reqParams = {'name': id};
    var payload = await RestClient.rpc(RPC.RPC_CONTAINER_IMAGE_REMOVE, parameters: reqParams);
    if (payload.metadata.success) {
      await listImages();
    }
    waitingImageRemove.value = false;
  }

  Future<void> searchImage() async {
    waitingImageSearch.value = true;
    searchImageList.clear();
    var name = searchImageEditingController.text;
    var reqParams = {'name': name};

    developer.log('Search image $name');

    var payload = await RestClient.rpc(RPC.RPC_CONTAINER_IMAGE_SEARCH, parameters: reqParams);
    if (payload.metadata.success) {
      var obj = (jsonDecode(payload.postJson) as List);
      searchImageList.value = obj.map((e) => ImageSearch.fromMap(e)).toList();
    }
    waitingImageSearch.value = false;
  }

  void pullImage(String name) async {
    developer.log('Pull image $name');
    var reqParams = {'name': name};
    var payload = await RestClient.rpc(RPC.RPC_CONTAINER_IMAGE_PULL, parameters: reqParams);
    if (payload.metadata.success) {
      var indexIndex = searchImageList.indexWhere((item) => item.name == name);
      var updatableItem = searchImageList[indexIndex];
      updatableItem.tag = 'JOS_PULL_IMAGE';
      searchImageList[indexIndex] = updatableItem;

      var pullItemImage = ContainerImage('', '', 0, 0, name, '');
      containerImageList.add(pullItemImage);
    }
  }

  void cancelPullImage(String name) async {
    developer.log('Cancel pull image $name');
    var reqParams = {'name': name};
    var payload = await RestClient.rpc(RPC.RPC_CONTAINER_IMAGE_PULL_CANCEL, parameters: reqParams);
    if (payload.metadata.success) {
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
    var payload = await RestClient.rpc(RPC.RPC_CONTAINER_VOLUME_LIST);
    if (payload.metadata.success) {
      var obj = (jsonDecode(payload.postJson) as List);
      volumeList.value = obj.map((e) => Volume.fromMap(e)).toList();
    }
  }

  void createVolume() async {
    var name = volumeNameEditingController.text;
    developer.log('Create volume $name');
    var reqParams = {'name': name};
    await RestClient.rpc(RPC.RPC_CONTAINER_VOLUME_CREATE, parameters: reqParams);
    await listVolumes().then((_) => Get.back()).then((_) => clean());
  }

  void removeVolume(String name) async {
    developer.log('Remove volume $name');
    var reqParams = {'name': name};
    await RestClient.rpc(RPC.RPC_CONTAINER_VOLUME_REMOVE, parameters: reqParams);
    await listVolumes();
  }

  /* Network methods */
  Future<void> listNetworks() async {
    developer.log('List networks');
    var payload = await RestClient.rpc(RPC.RPC_CONTAINER_NETWORK_LIST);
    if (payload.metadata.success) {
      var obj = (jsonDecode(payload.postJson) as List);
      networkList.value = obj.map((e) => NetworkInfo.fromMap(e)).toList();
    }
  }

  void createNetwork() async {
    var name = networkNameEditingController.text;
    var subnet = networkSubnetEditingController.text;
    var gateway = networkGatewayEditingController.text;
    developer.log('Create network $name');

    var network = Network(name, [Subnet(subnet, gateway)]);
    var networkJson = jsonEncode(network.toMap());

    var reqParams = {'network': networkJson};
    await RestClient.rpc(RPC.RPC_CONTAINER_NETWORK_CREATE, parameters: reqParams);
    await listNetworks().then((_) => Get.back()).then((_) async => await listNetworks());
  }

  void removeNetwork(String name) async {
    developer.log('Remove network $name');
    var reqParams = {'name': name};
    await RestClient.rpc(RPC.RPC_CONTAINER_NETWORK_REMOVE, parameters: reqParams);
    await listNetworks();
  }

  /* Container methods */
  Future<void> listContainers() async {
    developer.log('List containers');
    var payload = await RestClient.rpc(RPC.RPC_CONTAINER_LIST);
    if (payload.metadata.success) {
      var obj = (jsonDecode(payload.postJson) as List);
      containerList.value = obj.map((e) => ContainerInfo.fromMap(e)).toList();
    }
  }

  Future<void> killContainer(String name) async {
    developer.log('kill containers $name');
    var reqParams = {'name': name};
    var payload = await RestClient.rpc(RPC.RPC_CONTAINER_KILL, parameters: reqParams);
    if (!payload.metadata.success) {
      displayWarning('Failed to kill container $name');
    }
    await listContainers();
  }

  Future<void> stopContainer(String name) async {
    developer.log('stop containers $name');
    var reqParams = {'name': name};
    var payload = await RestClient.rpc(RPC.RPC_CONTAINER_STOP, parameters: reqParams);
    if (payload.metadata.success) {
      displayWarning('Failed to kill container $name');
    }
    await listContainers();
  }

  Future<void> removeContainer(String name) async {
    developer.log('remove containers $name');
    var reqParams = {'name': name};
    var payload = await RestClient.rpc(RPC.RPC_CONTAINER_REMOVE, parameters: reqParams);
    if (payload.metadata.success) {
      displayWarning('Failed to kill container $name');
    }
    await listContainers();
  }

  Future<void> startContainer(String name) async {
    developer.log('Start containers $name');
    var reqParams = {'name': name};
    var payload = await RestClient.rpc(RPC.RPC_CONTAINER_START, parameters: reqParams);
    if (payload.metadata.success) {
      displayWarning('Failed to kill container $name');
    }
    await listContainers();
  }

  void createContainer() async {
    var name = containerNameEditingController.text;
    var dnsSearch = containerDnsSearchEditingController.text;
    var dnsServer = containerDnsServerEditingController.text;
    var hostname = containerHostnameEditingController.text;
    var user = containerUserEditingController.text;
    var workDir = containerWorkDirEditingController.text;
    developer.log('Create container $name');

    var netns = {'nsmode': selectedNetwork.value!.driver};

    var container = CreateContainer(
      name,
      [dnsSearch],
      dnsServer.split(','),
      environments,
      useHostEnvironments.value,
      expose,
      hosts,
      hostname,
      selectedImage.value,
      null,
      privileged.value,
      user,
      workDir,
      connectVolumes,
      portMappings,
      networkConnect,
      netns,
    );

    var reqParams = {'container': jsonEncode(container)};
    await RestClient.rpc(RPC.RPC_CONTAINER_CREATE, parameters: reqParams);
    await listNetworks().then((_) => Get.back()).then((_) async => await listNetworks());
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
    var volume = VolumeParameter(dest, name, null);
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
    selectedNetwork.close();
  }

  void clean() {
    searchImageList.clear();
    searchImageEditingController.clear();
    volumeNameEditingController.clear();
  }
}
