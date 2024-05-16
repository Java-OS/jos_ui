import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/model/filesystem.dart';
import 'package:jos_ui/model/filesystem_tree.dart';
import 'package:jos_ui/protobuf/message-buffer.pb.dart';
import 'package:jos_ui/service/rest_client.dart';
import 'package:jos_ui/widget/toast.dart';

class FilesystemController extends GetxController {
  final TextEditingController partitionEditingController = TextEditingController();
  final TextEditingController mountPointEditingController = TextEditingController();
  final TextEditingController filesystemTypeEditingController = TextEditingController();
  final TextEditingController newFolderEditingController = TextEditingController();

  var partitions = <HDDPartition>[].obs;
  var selectedPartition = Rxn<HDDPartition>();
  var mountOnStartUp = false.obs;
  var filesystemTree = Rxn<FilesystemTree>();
  var path = ''.obs;
  var listPath = <String>[].obs;

  Future<void> fetchPartitions() async {
    developer.log('Fetch filesystems');
    var payload = await RestClient.rpc(RPC.RPC_FILESYSTEM_LIST);
    if (payload.metadata.success) {
      var result = jsonDecode(payload.postJson) as List;
      partitions.value = result.map((e) => HDDPartition.fromJson(e)).toList();
    } else {
      displayError('Failed to fetch filesystems');
    }
  }

  void mount() async {
    var mountPoint = mountPointEditingController.text;
    var fsType = filesystemTypeEditingController.text;
    var partition = partitions.firstWhere((element) => element.partition == partitionEditingController.text);
    var reqParam = {
      'uuid': partition.uuid,
      'type': fsType,
      'mountPoint': mountPoint,
      'mountOnStartUp': mountOnStartUp.value,
    };

    developer.log('$reqParam');
    var payload = await RestClient.rpc(RPC.RPC_FILESYSTEM_MOUNT, parameters: reqParam);
    if (payload.metadata.success) {
      await fetchPartitions();
      clear();
      Get.back();
      displayInfo('Successfully mounted on [$mountPoint]');
    }
  }

  void umount(HDDPartition partition) async {
    developer.log('Umount partition ${partition.partition}');
    var reqParam = {
      'uuid': partition.uuid,
    };
    developer.log('$reqParam');
    var payload = await RestClient.rpc(RPC.RPC_FILESYSTEM_UMOUNT, parameters: reqParam);
    if (payload.metadata.success) {
      await fetchPartitions();
      displayInfo('Successfully disconnected');
    }
  }

  void swapOn(HDDPartition partition) async {
    developer.log('SwapOn ${partition.type}   ${partition.uuid}');
    var reqParam = {
      'uuid': partition.uuid,
    };
    developer.log('$reqParam');
    var payload = await RestClient.rpc(RPC.RPC_FILESYSTEM_SWAP_ON, parameters: reqParam);
    if (payload.metadata.success) {
      await fetchPartitions();
    } else {
      displayWarning('Failed to activate swap ${partition.partition}');
    }
  }

  void swapOff(HDDPartition partition) async {
    developer.log('SwapOff ${partition.type}   ${partition.uuid}');
    var reqParam = {
      'uuid': partition.uuid,
    };
    developer.log('$reqParam');
    var payload = await RestClient.rpc(RPC.RPC_FILESYSTEM_SWAP_OFF, parameters: reqParam);
    if (payload.metadata.success) {
      await fetchPartitions();
    } else {
      displayWarning('Failed to deactivate swap ${partition.partition}');
    }
  }

  Future<void> fetchFilesystemTree(String rootPath) async {
    var reqParam = {
      'rootDir': rootPath,
    };
    var payload = await RestClient.rpc(RPC.RPC_FILESYSTEM_DIRECTORY_TREE, parameters: reqParam);
    if (payload.metadata.success) {
      var json = jsonDecode(payload.postJson);
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
    var payload = await RestClient.rpc(RPC.RPC_FILESYSTEM_DELETE_FILE, parameters: reqParam);
    if (!payload.metadata.success) {
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
    var payload = await RestClient.rpc(RPC.RPC_FILESYSTEM_CREATE_DIRECTORY, parameters: reqParam);
    if (!payload.metadata.success) {
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
    var payload = await RestClient.rpc(RPC.RPC_FILESYSTEM_EXTRACT_ARCHIVE, parameters: reqParam);
    if (payload.metadata.success) {
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
