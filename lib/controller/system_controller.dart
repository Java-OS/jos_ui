import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/dialog/alert_dialog.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/service/api_service.dart';

class SystemController extends GetxController {
  final _apiService = Get.put(ApiService());
  final TextEditingController dnsEditingController = TextEditingController();
  final TextEditingController hostnameEditingController = TextEditingController();

  var osUsername = ''.obs;
  var osCodeName = ''.obs;
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
    _apiService.callApi(Rpc.RPC_SYSTEM_GET_HOSTNAME, message: 'Failed to fetch hostname').then((map) {
      osHostname.value = map['hostname'];
      hostnameEditingController.text = map['hostname'];
    });
  }

  Future<void> changeHostname() async {
    developer.log('Change hostname called');
    bool accepted = await displayAlertModal('Warning', 'JVM must be restarted for the changes to take effect');
    if (accepted) {
      _apiService.callApi(Rpc.RPC_SYSTEM_SET_HOSTNAME, parameters: {'hostname': hostnameEditingController.text}, message: 'Failed to change hostname').then((e) => Get.back()).then((e) => fetchHostname());
    }
  }

  Future<void> fetchSystemInformation() async {
    developer.log('Fetch System Full Information');
    _apiService.callApi(Rpc.RPC_SYSTEM_FULL_INFORMATION,disableLoading: true).then((map) {
      dateTimeZone.value = map['os_date_time_zone'].toString();
      osUsername.value = map['os_username'].toString();
      osVersion.value = map['os_version'].toString();
      osCodeName.value = map['os_codename'].toString();
      osHostname.value = map['os_hostname'].toString();
      hwCpuInfo.value = map['hw_cpu_info'].toString();
      hwCpuCount.value = map['hw_cpu_count'].toString();
      hwTotalMemory.value = map['hw_total_memory'];
      hwUsedMemory.value = map['hw_used_memory'];
      hwFreeMemory.value = map['hw_free_memory'];
      jvmVendor.value = map['jvm_vendor'].toString();
      jvmVersion.value = map['jvm_version'].toString();
      jvmMaxHeapSize.value = map['jvm_max_heap_size'];
      jvmTotalHeapSize.value = map['jvm_total_heap_size'];
      jvmUsedHeapSize.value = map['jvm_used_heap_size'];
    });
  }

  Future<void> fetchDnsNameserver() async {
    developer.log('fetch dns nameserver');
    _apiService.callApi(Rpc.RPC_NETWORK_GET_DNS_NAMESERVER, message: 'Failed to fetch dns nameserver').then((map) => dnsEditingController.text = map['nameserver']);
  }

  void setDnsNameserver() async {
    var dns = dnsEditingController.text;
    developer.log('Set dns nameserver  $dns');
    var reqParam = {
      'ips': dns,
    };
    _apiService.callApi(Rpc.RPC_NETWORK_SET_DNS_NAMESERVER, parameters: reqParam, message: 'Failed to change nameserver').then((e) => Get.back()).then((e) => clean()).then((e) => fetchDnsNameserver());
  }

  void systemReboot() async {
    _apiService.callApi(Rpc.RPC_SYSTEM_REBOOT, message: 'Reboot failed');
  }

  void systemShutdown() async {
    _apiService.callApi(Rpc.RPC_SYSTEM_SHUTDOWN, message: 'Shutdown failed');
  }

  void clean() {
    dnsEditingController.clear();
    hostnameEditingController.clear();
  }
}
