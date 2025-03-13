import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/event_controller.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/model/filesystem.dart';
import 'package:jos_ui/model/filesystem_tree.dart';
import 'package:jos_ui/service/api_service.dart';

class FilesystemController extends GetxController {
  final _apiService = Get.put(ApiService());
  final _eventController = Get.put(EventController());

  final TextEditingController partitionEditingController = TextEditingController();
  final TextEditingController mountPointEditingController = TextEditingController();
  final TextEditingController filesystemTypeEditingController = TextEditingController();
  final TextEditingController newFolderEditingController = TextEditingController();
  final TextEditingController archiveFileNameEditingController = TextEditingController();

  var partitions = <PartitionInformation>[].obs;
  var selectedPartition = Rxn<PartitionInformation>();
  var mountOnStartUp = false.obs;
  var filesystemTree = Rxn<FilesystemTree>();
  var selectedItems = <String>[].obs;
  var copyItems = <String>[].obs;
  var cuteItems = <String>[].obs;
  var directoryPath = ''.obs;

  var treeView = Rxn<FilesystemTree>();

  Future<void> fetchPartitions() async {
    developer.log('Fetch filesystems');
    _apiService.callApi(Rpc.RPC_FILESYSTEM_LIST, message: 'Failed to fetch filesystems').then((map) => map as List).then((list) => partitions.value = list.map((e) => PartitionInformation.fromJson(e)).toList());
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

  Future<void> fetchFilesystemTree() async {
    var reqParam = {'rootDir': directoryPath.value};
    var map = await _apiService.callApi(Rpc.RPC_FILESYSTEM_DIRECTORY_TREE, parameters: reqParam, disableLoading: true);
    filesystemTree.value = FilesystemTree.fromMap(map);
  }

  Future<void> delete() async {
    developer.log('Delete file $selectedItems');
    var reqParam = {'paths': selectedItems};
    var map = await _apiService.callApi(Rpc.RPC_FILESYSTEM_DELETE_FILE, parameters: reqParam);
    filesystemTree.value = FilesystemTree.fromMap(map);
    selectedItems.clear();
    _eventController.eventFetch();
  }

  Future<void> createDir() async {
    var basePath = directoryPath.value;
    var dirName = newFolderEditingController.text;
    developer.log('Create new folder $basePath/$dirName');
    var reqParam = {'path': '$basePath/$dirName'};
    var map = await _apiService.callApi(Rpc.RPC_FILESYSTEM_CREATE_DIRECTORY, parameters: reqParam, message: 'Failed to create new folder $dirName');
    filesystemTree.value = FilesystemTree.fromMap(map);
    newFolderEditingController.clear();
  }

  Future<void> createArchive() async {
    var fileName = archiveFileNameEditingController.text;
    developer.log('compress archive $fileName');
    var reqParam = {'list': selectedItems.toList(), 'archiveName': fileName};
    var map = await _apiService.callApi(Rpc.RPC_FILESYSTEM_CREATE_ARCHIVE, parameters: reqParam, message: 'Failed to create archive $fileName');
    filesystemTree.value = FilesystemTree.fromMap(map);
    _eventController.eventFetch();
  }

  void extractArchive(String path) async {
    developer.log('Extract archive $path');
    var reqParam = {'zipFile': path};
    var map = await _apiService.callApi(Rpc.RPC_FILESYSTEM_EXTRACT_ARCHIVE, parameters: reqParam, message: 'Failed extract archive $path');
    filesystemTree.value = FilesystemTree.fromMap(map);
    _eventController.eventFetch();
    selectedItems.clear();
  }

  void paste() async {
    developer.log('Copy or Move files to ${directoryPath.value}');
    var reqParam = {
      'list': copyItems.isNotEmpty ? copyItems.toList() : cuteItems.toList(),
      'target': directoryPath.value,
    };
    var map = await _apiService.callApi(copyItems.isNotEmpty ? Rpc.RPC_FILESYSTEM_COPY_FILE : Rpc.RPC_FILESYSTEM_MOVE_FILE, parameters: reqParam, message: 'Failed copy/move files to ${directoryPath.value}');
    if (map != null) filesystemTree.value = FilesystemTree.fromMap(map);

    copyItems.clear();
    cuteItems.clear();
    _eventController.eventFetch();
  }

  void clear() {
    partitionEditingController.clear();
    mountPointEditingController.clear();
    filesystemTypeEditingController.clear();
    filesystemTree = Rxn<FilesystemTree>();
    directoryPath = ''.obs;
  }
}
