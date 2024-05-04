import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/model/container/ContainerImage.dart';
import 'package:jos_ui/model/container/image_search.dart';
import 'package:jos_ui/protobuf/message-buffer.pb.dart';
import 'package:jos_ui/service/rest_client.dart';

class ContainerController extends GetxController {
  final TextEditingController searchImageEditingController = TextEditingController();

  var searchImageList = <ImageSearch>[].obs;
  var containerImageList = <ContainerImage>[].obs;
  var waitingSearchImages = false.obs;
  var waitingRemoveImage = false.obs;

  Future<void> listImages() async {
    developer.log('List images');
    var payload = await RestClient.rpc(RPC.RPC_CONTAINER_IMAGE_LIST);
    if (payload.metadata.success) {
      var obj = (jsonDecode(payload.postJson) as List);
      containerImageList.value = obj.map((e) => ContainerImage.fromMap(e)).toList();
    }
  }

  Future<void> removeImage(String id) async {
    waitingRemoveImage.value = true;
    developer.log('remove image $id');
    var reqParams = {'name': id};
    var payload = await RestClient.rpc(RPC.RPC_CONTAINER_IMAGE_REMOVE, parameters: reqParams);
    if (payload.metadata.success) {
      await listImages();
    }
    waitingRemoveImage.value = false;
  }

  Future<void> searchImage() async {
    waitingSearchImages.value = true;
    searchImageList.clear();
    var name = searchImageEditingController.text;
    var reqParams = {'name': name};

    developer.log('Search image $name');

    var payload = await RestClient.rpc(RPC.RPC_CONTAINER_IMAGE_SEARCH, parameters: reqParams);
    if (payload.metadata.success) {
      var obj = (jsonDecode(payload.postJson) as List);
      var installedImage = containerImageList.firstWhere((e) => e.name == name);
      searchImageList.value = obj.map((e) => ImageSearch.fromMap(e)).toList();
    }
    waitingSearchImages.value = false;
  }

  void pullImage(String name) async {
    var reqParams = {'name': name};
    developer.log('Pull image $name');
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
    var reqParams = {'name': name};
    developer.log('Cancel pull image $name');
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

  bool isInstalled(String name) {
    return containerImageList.map((e) => e.name).contains(name);
  }

  void clean() {
    searchImageList.clear();
    searchImageEditingController.clear();
  }
}
