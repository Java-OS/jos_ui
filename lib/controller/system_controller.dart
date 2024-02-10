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
  var filesystems = <HDDPartition>[].obs;
  var mountOnStartUp = false.obs;
  var filesystemTree = Rxn<FilesystemTree>();

  Future<void> fetchHostname() async {
    developer.log('Fetch hostname called');
    var response = await RestClient.rpc(RPC.systemGetHostname);
    if (response.result != null) {
      osHostname.value = response.result;
      hostnameEditingController.text = response.result;
    } else {
      displayError('Failed to fetch hostname');
    }
  }

  Future<void> changeHostname() async {
    developer.log('Change hostname called');
    bool accepted = await displayAlertModal('Warning', 'JVM immediately must be reset after change hostname.');
    if (accepted) {
      var response = await RestClient.rpc(RPC.systemSetHostname, parameters: {'hostname': hostnameEditingController.text});
      if (response.success) {
        displaySuccess('Hostname changed');
      } else {
        displayWarning('Failed to change hostname');
      }
    }
  }

  void fetchSystemInformation() async {
    developer.log('Fetch System Full Information');
    var response = await RestClient.rpc(RPC.systemFullInformation);
    if (response.result != null) {
      var json = response.result;
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

  Future<void> fetchFilesystems() async {
    developer.log('Fetch filesystems');
    var response = await RestClient.rpc(RPC.filesystemList);
    if (response.success) {
      var result = response.result as List;
      filesystems.value = result.map((e) => HDDPartition.fromJson(e)).toList();
    } else {
      displayError('Failed to fetch filesystems');
    }
  }

  void mountFilesystem() async {
    var mountPoint = mountPointEditingController.text;
    var fsType = filesystemTypeEditingController.text;
    var partition = filesystems.firstWhere((element) => element.partition == partitionEditingController.text);
    var reqParam = {
      'uuid': partition.uuid,
      'type': fsType,
      'mountPoint': mountPoint,
      'mountOnStartUp': mountOnStartUp.value,
    };
    var response = await RestClient.rpc(RPC.filesystemMount, parameters: reqParam);
    if (response.success) {
      await fetchFilesystems();
      clear();
      Get.back();
      displayInfo('Filesystem successfully mounted on \\n [ $mountPoint ]');
    }
  }

  void umountFilesystem() async {
    var mountPoint = mountPointEditingController.text;
    var reqParam = {
      'mountPoint': mountPoint,
    };
    var response = await RestClient.rpc(RPC.filesystemUmount, parameters: reqParam);
    if (response.success) {
      await fetchFilesystems();
      Get.back();
      displayInfo('Filesystem successfully disconnected');
    }
  }

  Future<void> fetchFilesystemTree() async {
    var mountPoint = mountPointEditingController.text;
    var reqParam = {
      'rootDir': mountPoint,
    };
    var response = await RestClient.rpc(RPC.filesystemDirectoryTree, parameters: reqParam);
    if (response.success) {
      filesystemTree.value = FilesystemTree.fromJson(response.result);
    }
  }

  void clear() {
    partitionEditingController.clear();
    mountPointEditingController.clear();
  }
}
