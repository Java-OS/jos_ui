import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/dialog/alert_dialog.dart';
import 'package:jos_ui/dialog/toast.dart';
import 'package:jos_ui/model/filesystem.dart';
import 'package:jos_ui/model/filesystem_tree.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/service/rest_client.dart';

class SystemController extends GetxController {
  final TextEditingController dnsEditingController = TextEditingController();
  final TextEditingController hostnameEditingController = TextEditingController();
  final TextEditingController partitionEditingController = TextEditingController();
  final TextEditingController mountPointEditingController = TextEditingController();
  final TextEditingController filesystemTypeEditingController = TextEditingController();

  var osUsername = ''.obs;
  var osType = ''.obs;
  var osVersion = ''.obs;
  var osHostname = ''.obs;
  var hwCpuInfo = ''.obs;
  var hwCpuCount = ''.obs;
  var hwTotalMemory = 0.obs;
  var hwUsedMemory = 0.obs;
  var hwFreeMemory = 0.obs;
  var jvmVendor = ''.obs;
  var jvmVersion = ''.obs;
  var jvmMaxHeapSize = 0.obs;
  var jvmTotalHeapSize = 0.obs;
  var jvmUsedHeapSize = 0.obs;
  var dateTimeZone = ''.obs;
  var partitions = <HDDPartition>[].obs;
  var selectedPartition = Rxn<HDDPartition>();
  var mountOnStartUp = false.obs;
  var filesystemTree = Rxn<FilesystemTree>();

  Future<void> fetchHostname() async {
    developer.log('Fetch hostname called');
    var payload = await RestClient.rpc(RPC.systemGetHostname);
    if (payload.metadata.success) {
      var json = jsonDecode(payload.postJson);
      osHostname.value = json;
      hostnameEditingController.text = json;
    } else {
      displayError('Failed to fetch hostname');
    }
  }

  Future<void> changeHostname() async {
    developer.log('Change hostname called');
    bool accepted = await displayAlertModal('Warning', 'JVM should be restarted for the changes to take effect');
    if (accepted) {
      var payload = await RestClient.rpc(RPC.systemSetHostname, parameters: {'hostname': hostnameEditingController.text});
      if (payload.metadata.success) {
        displaySuccess('Hostname changed');
        Get.back();
      } else {
        displayWarning('Failed to change hostname');
      }
    }
  }

  void fetchSystemInformation() async {
    developer.log('Fetch System Full Information');
    var payload = await RestClient.rpc(RPC.systemFullInformation);
    if (payload.metadata.success) {
      var json = jsonDecode(payload.postJson);
      dateTimeZone.value = json['os_date_time_zone'].toString();
      osUsername.value = json['os_username'].toString();
      osVersion.value = json['os_version'].toString();
      osType.value = json['os_type'].toString();
      osHostname.value = json['os_hostname'].toString();
      hwCpuInfo.value = json['hw_cpu_info'].toString();
      hwCpuCount.value = json['hw_cpu_count'].toString();
      hwTotalMemory.value = json['hw_total_memory'];
      hwUsedMemory.value = json['hw_used_memory'];
      hwFreeMemory.value = json['hw_free_memory'];
      jvmVendor.value = json['jvm_vendor'].toString();
      jvmVersion.value = json['jvm_version'].toString();
      jvmMaxHeapSize.value = json['jvm_max_heap_size'];
      jvmTotalHeapSize.value = json['jvm_total_heap_size'];
      jvmUsedHeapSize.value = json['jvm_used_heap_size'];
    }
  }

  Future<void> fetchPartitions() async {
    developer.log('Fetch filesystems');
    var payload = await RestClient.rpc(RPC.filesystemList);
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
    var payload = await RestClient.rpc(RPC.filesystemMount, parameters: reqParam);
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
    var payload = await RestClient.rpc(RPC.filesystemUmount, parameters: reqParam);
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
    var payload = await RestClient.rpc(RPC.filesystemSwapOn, parameters: reqParam);
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
    var payload = await RestClient.rpc(RPC.filesystemSwapOff, parameters: reqParam);
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
    var payload = await RestClient.rpc(RPC.filesystemDirectoryTree, parameters: reqParam);
    if (payload.metadata.success) {
      var json = jsonDecode(payload.postJson);
      var tree = FilesystemTree.fromJson(json);
      if (filesystemTree.value == null) {
        filesystemTree.value = tree;
      } else {
        var foundedTree = walkToFindFilesystemTree(filesystemTree.value!, rootPath);
        if (foundedTree != null && foundedTree.childs!.isEmpty) {
          foundedTree.childs!.addAll(tree.childs!);
        }
      }
    }
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
  }

  Future<void> fetchDnsNameserver() async {
    developer.log('fetch dns nameserver');
    var payload = await RestClient.rpc(RPC.networkGetDnsNameserver);
    if (payload.metadata.success) {
      var json = jsonDecode(payload.postJson);
      dnsEditingController.text = json;
    } else {
      displayWarning('Failed to fetch dns nameserver');
    }
  }

  void setDnsNameserver() async {
    var dns = dnsEditingController.text;
    developer.log('Set dns nameserver  $dns');
    var reqParam = {
      'ips': dns,
    };
    var payload = await RestClient.rpc(RPC.networkSetDnsNameserver, parameters: reqParam);
    if (payload.metadata.success) {
      clear();
      Get.back();
    } else {
      displayWarning('Failed to change nameserver');
    }
  }

  void systemReboot() async {
    var payload = await RestClient.rpc(RPC.systemReboot);
    if (payload.metadata.success) {
      displayInfo('Reboot success');
    } else {
      displayError('Reboot failed');
    }
  }

  void systemShutdown() async {
    var payload = await RestClient.rpc(RPC.systemShutdown);
    if (payload.metadata.success) {
      displayInfo('The system was completely shutdown');
    } else {
      displayError('Shutdown failed');
    }
  }

  void clear() {
    dnsEditingController.clear();
    hostnameEditingController.clear();
    partitionEditingController.clear();
    mountPointEditingController.clear();
    filesystemTypeEditingController.clear();
    filesystemTree = Rxn<FilesystemTree>();
  }
}
