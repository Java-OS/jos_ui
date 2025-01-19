import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/model/filesystem.dart';
import 'package:jos_ui/model/filesystem_tree.dart';
import 'package:jos_ui/service/api_service.dart';
import 'package:jos_ui/service/rest_client.dart';

class FilesystemController extends GetxController {
  final _apiService = Get.put(ApiService());
  final TextEditingController partitionEditingController = TextEditingController();
  final TextEditingController mountPointEditingController = TextEditingController();
  final TextEditingController filesystemTypeEditingController = TextEditingController();
  final TextEditingController newFolderEditingController = TextEditingController();

  var partitions = <PartitionInformation>[].obs;
  var selectedPartition = Rxn<PartitionInformation>();
  var mountOnStartUp = false.obs;
  var filesystemTree = Rxn<FilesystemTree>();
  var path = ''.obs;
  var listPath = <String>[].obs;

  Future<void> fetchPartitions() async {
    developer.log('Fetch filesystems');
    _apiService
        .callApi(Rpc.RPC_FILESYSTEM_LIST, message: 'Failed to fetch filesystems')
        .then((map) => map as List)
        .then((list) => partitions.value = list.map((e) => PartitionInformation.fromJson(e)).toList());
  }

  void mount() async {
    var mountPoint = mountPointEditingController.text;
    var fsType = filesystemTypeEditingController.text;
    var partition = partitions.firstWhere((element) => element.blk == partitionEditingController.text);
    var reqParam = {
      'uuid': partition.uuid,
      'type': fsType,
      'mountPoint': mountPoint,
      'mountOnStartUp': mountOnStartUp.value,
    };
    _apiService.callApi(Rpc.RPC_FILESYSTEM_MOUNT, parameters: reqParam).then((e) => fetchPartitions()).then((e) => clear()).then((e) => Get.back());
  }

  void umount(PartitionInformation partition) async {
    developer.log('Umount partition ${partition.blk}');
    var reqParam = {'uuid': partition.uuid};
    _apiService.callApi(Rpc.RPC_FILESYSTEM_UMOUNT, parameters: reqParam).then((e) => fetchPartitions());
  }

  void swapOn(PartitionInformation partition) async {
    developer.log('SwapOn ${partition.type}   ${partition.uuid}');
    var reqParam = {'uuid': partition.uuid};
    _apiService.callApi(Rpc.RPC_FILESYSTEM_SWAP_ON, parameters: reqParam, message: 'Failed to activate swap ${partition.blk}').then((e) => fetchPartitions());
  }

  void swapOff(PartitionInformation partition) async {
    developer.log('SwapOff ${partition.type}   ${partition.uuid}');
    var reqParam = {'uuid': partition.uuid};
    _apiService.callApi(Rpc.RPC_FILESYSTEM_SWAP_OFF, parameters: reqParam, message: 'Failed to deactivate swap ${partition.blk}').then((e) => fetchPartitions());
  }

  Future<void> fetchFilesystemTree(String rootPath) async {
    var reqParam = {'rootDir': rootPath};
    _apiService.callApi(Rpc.RPC_FILESYSTEM_DIRECTORY_TREE, parameters: reqParam).then((map) {
      var tree = FilesystemTree.fromMap(map);
      if (filesystemTree.value == null) {
        filesystemTree.value = tree;
      } else {
        if (filesystemTree.value!.fullPath == tree.fullPath) {
          filesystemTree.value!.childs!.clear();
          filesystemTree.value!.childs!.addAll(tree.childs!);
        }
        var foundedTree = walkToFindFilesystemTree(filesystemTree.value!, rootPath);
        if (foundedTree != null && foundedTree.childs!.isEmpty) {
          foundedTree.childs!.addAll(tree.childs!);
        }
      }
    }).then((e) => filesystemTree.refresh());
  }

  FilesystemTree? walkToFindFilesystemTree(FilesystemTree tree, String absolutePath) {
    if (tree.fullPath == absolutePath) {
      return tree;
    }
    var dirList = tree.childs!.where((element) => !element.isFile).toList();
    if (dirList.isEmpty) return null;
    for (FilesystemTree child in dirList) {
      if (child.fullPath == absolutePath) {
        return child;
      } else {
        var w = walkToFindFilesystemTree(child, absolutePath);
        if (w == null) continue;
        return w;
      }
    }
    return null;
  }

  Future<void> delete(String filePath) async {
    developer.log('Delete file $filePath');
    var reqParam = {'path': filePath};
    _apiService.callApi(Rpc.RPC_FILESYSTEM_DELETE_FILE, parameters: reqParam, message: 'Failed to delete $filePath');
  }

  Future<void> createDir(String basePath) async {
    var path = newFolderEditingController.text;
    developer.log('Create new folder $basePath/$path');
    var reqParam = {'path': '$basePath/$path'};
    _apiService.callApi(Rpc.RPC_FILESYSTEM_CREATE_DIRECTORY, parameters: reqParam, message: 'Failed to create new folder $path').then((e) => newFolderEditingController.clear());
  }

  void extractArchive(String path) async {
    developer.log('Extract archive $path');
    var reqParam = {'target': path};
    _apiService.callApi(Rpc.RPC_FILESYSTEM_EXTRACT_ARCHIVE, parameters: reqParam, message: 'Failed to create directory $path').then((e) => fetchPartitions());
  }

  void download(String filePath) async {
    await RestClient.download(filePath, null);
  }

  void clear() {
    partitionEditingController.clear();
    mountPointEditingController.clear();
    filesystemTypeEditingController.clear();
    filesystemTree = Rxn<FilesystemTree>();
  }
}
