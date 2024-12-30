import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/model/filesystem.dart';
import 'package:jos_ui/model/filesystem_tree.dart';
import 'package:jos_ui/model/protocol/rpc.dart';
import 'package:jos_ui/service/rest_client.dart';
import 'package:jos_ui/widget/toast.dart';

class FilesystemController extends GetxController {
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
    var payload = await RestClient.rpc(RPC.rpcFilesystemList);
    if (payload.isSuccess()) {
      var result = jsonDecode(payload.content!) as List;
      partitions.value = result.map((e) => PartitionInformation.fromJson(e)).toList();
    } else {
      displayError('Failed to fetch filesystems');
    }
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

    developer.log('$reqParam');
    var payload = await RestClient.rpc(RPC.rpcFilesystemMount, parameters: reqParam);
    if (payload.isSuccess()) {
      await fetchPartitions();
      clear();
      Get.back();
      displayInfo('Successfully mounted on [$mountPoint]');
    }
  }

  void umount(PartitionInformation partition) async {
    developer.log('Umount partition ${partition.blk}');
    var reqParam = {
      'uuid': partition.uuid,
    };
    developer.log('$reqParam');
    var payload = await RestClient.rpc(RPC.rpcFilesystemUmount, parameters: reqParam);
    if (payload.isSuccess()) {
      await fetchPartitions();
      displayInfo('Successfully disconnected');
    }
  }

  void swapOn(PartitionInformation partition) async {
    developer.log('SwapOn ${partition.type}   ${partition.uuid}');
    var reqParam = {
      'uuid': partition.uuid,
    };
    developer.log('$reqParam');
    var payload = await RestClient.rpc(RPC.rpcFilesystemSwapOn, parameters: reqParam);
    if (payload.isSuccess()) {
      await fetchPartitions();
    } else {
      displayWarning('Failed to activate swap ${partition.blk}');
    }
  }

  void swapOff(PartitionInformation partition) async {
    developer.log('SwapOff ${partition.type}   ${partition.uuid}');
    var reqParam = {
      'uuid': partition.uuid,
    };
    developer.log('$reqParam');
    var payload = await RestClient.rpc(RPC.rpcFilesystemSwapOff, parameters: reqParam);
    if (payload.isSuccess()) {
      await fetchPartitions();
    } else {
      displayWarning('Failed to deactivate swap ${partition.blk}');
    }
  }

  Future<void> fetchFilesystemTree(String rootPath) async {
    var reqParam = {
      'rootDir': rootPath,
    };
    var payload = await RestClient.rpc(RPC.rpcFilesystemDirectoryTree, parameters: reqParam);
    if (payload.isSuccess()) {
      var json = jsonDecode(payload.content!);
      var tree = FilesystemTree.fromJson(json);
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
    }

    filesystemTree.refresh();
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
    var reqParam = {
      'path': filePath,
    };
    developer.log('$reqParam');
    var payload = await RestClient.rpc(RPC.rpcFilesystemDeleteFile, parameters: reqParam);
    if (!payload.isSuccess()) {
      displayWarning('Failed to delete $filePath');
    }
  }

  Future<void> createDir(String basePath) async {
    var path = newFolderEditingController.text;
    developer.log('Create new folder $basePath/$path');
    var reqParam = {
      'path': '$basePath/$path',
    };
    developer.log('$reqParam');
    var payload = await RestClient.rpc(RPC.rpcFilesystemCreateDirectory, parameters: reqParam);
    if (!payload.isSuccess()) {
      displayWarning('Failed to create new folder $path');
    }

    newFolderEditingController.clear();
  }

  void extractArchive(String path) async {
    developer.log('Extract archive $path');
    var reqParam = {
      'target': path,
    };
    developer.log('$reqParam');
    var payload = await RestClient.rpc(RPC.rpcFilesystemExtractArchive, parameters: reqParam);
    if (payload.isSuccess()) {
      await fetchPartitions();
    } else {
      displayWarning('Failed to create directory $path');
    }
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
