import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/dialog/alert_dialog.dart';
import 'package:jos_ui/model/protocol/rpc.dart';
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
    var payload = await RestClient.rpc(RPC.rpcSystemGetHostname);
    if (payload.isSuccess()) {
      var json = jsonDecode(payload.content!);
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
      var payload = await RestClient.rpc(RPC.rpcSystemSetHostname, parameters: {'hostname': hostnameEditingController.text});
      if (payload.isSuccess()) {
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
    var payload = await RestClient.rpc(RPC.rpcSystemFullInformation);
    if (payload.isSuccess()) {
      var json = jsonDecode(payload.content!);
      dateTimeZone.value = json['osDateTimeZone'].toString();
      osUsername.value = json['osUsername'].toString();
      osVersion.value = json['osVersion'].toString();
      osType.value = json['osType'].toString();
      osHostname.value = json['osHostname'].toString();
      hwCpuInfo.value = json['hwCpuInfo'].toString();
      hwCpuCount.value = json['hwCpuCount'].toString();
      hwTotalMemory.value = json['hwTotalMemory'];
      hwUsedMemory.value = json['hwUsedMemory'];
      hwFreeMemory.value = json['hwFreeMemory'];
      jvmVendor.value = json['jvmVendor'].toString();
      jvmVersion.value = json['jvmVersion'].toString();
      jvmMaxHeapSize.value = json['jvmMaxHeapSize'];
      jvmTotalHeapSize.value = json['jvmTotalHeapSize'];
      jvmUsedHeapSize.value = json['jvmUsedHeapSize'];
    }
  }

  Future<void> fetchDnsNameserver() async {
    developer.log('fetch dns nameserver');
    var payload = await RestClient.rpc(RPC.rpcNetworkGetDnsNameserver);
    if (payload.isSuccess()) {
      var json = jsonDecode(payload.content!);
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
    var payload = await RestClient.rpc(RPC.rpcNetworkSetDnsNameserver, parameters: reqParam);
    if (payload.isSuccess()) {
      clear();
      Get.back();
    } else {
      displayWarning('Failed to change nameserver');
    }
    await fetchDnsNameserver();
  }

  void systemReboot() async {
    var payload = await RestClient.rpc(RPC.rpcSystemReboot);
    if (payload.isSuccess()) {
      displayInfo('Reboot success');
    } else {
      displayError('Reboot failed');
    }
  }

  void systemShutdown() async {
    var payload = await RestClient.rpc(RPC.rpcSystemShutdown);
    if (payload.isSuccess()) {
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
