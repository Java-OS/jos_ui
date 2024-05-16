import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/dialog/alert_dialog.dart';
import 'package:jos_ui/protobuf/message-buffer.pb.dart';
import 'package:jos_ui/service/rest_client.dart';
import 'package:jos_ui/widget/toast.dart';

class SystemController extends GetxController {
  final TextEditingController dnsEditingController = TextEditingController();
  final TextEditingController hostnameEditingController = TextEditingController();

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

  Future<void> fetchHostname() async {
    developer.log('Fetch hostname called');
    var payload = await RestClient.rpc(RPC.RPC_SYSTEM_GET_HOSTNAME);
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
      var payload = await RestClient.rpc(RPC.RPC_SYSTEM_SET_HOSTNAME, parameters: {'hostname': hostnameEditingController.text});
      if (payload.metadata.success) {
        displaySuccess('Hostname changed');
        Get.back();
      } else {
        displayWarning('Failed to change hostname');
      }
      await fetchHostname();
    }
  }

  void fetchSystemInformation() async {
    developer.log('Fetch System Full Information');
    var payload = await RestClient.rpc(RPC.RPC_SYSTEM_FULL_INFORMATION);
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

  Future<void> fetchDnsNameserver() async {
    developer.log('fetch dns nameserver');
    var payload = await RestClient.rpc(RPC.RPC_NETWORK_GET_DNS_NAMESERVER);
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
    var payload = await RestClient.rpc(RPC.RPC_NETWORK_SET_DNS_NAMESERVER, parameters: reqParam);
    if (payload.metadata.success) {
      clear();
      Get.back();
    } else {
      displayWarning('Failed to change nameserver');
    }
    await fetchDnsNameserver();
  }

  void systemReboot() async {
    var payload = await RestClient.rpc(RPC.RPC_SYSTEM_REBOOT);
    if (payload.metadata.success) {
      displayInfo('Reboot success');
    } else {
      displayError('Reboot failed');
    }
  }

  void systemShutdown() async {
    var payload = await RestClient.rpc(RPC.RPC_SYSTEM_SHUTDOWN);
    if (payload.metadata.success) {
      displayInfo('The system was completely shutdown');
    } else {
      displayError('Shutdown failed');
    }
  }

  void clear() {
    dnsEditingController.clear();
    hostnameEditingController.clear();
  }
}
