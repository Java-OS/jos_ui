import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/modal/toast.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/service/RpcProvider.dart';

class DashboardController extends GetxController {
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

  void fetchSystemInformation() async {
    developer.log('Fetch System Full Information');
    var response = await RestClient.rpc(RPC.systemFullInformation);
    if (response != null) {
      var json = jsonDecode(response);
      dateTimeZone.value = json['result']['os_date_time_zone'].toString();
      osUsername.value = json['result']['os_username'].toString();
      osVersion.value = json['result']['os_version'].toString();
      osType.value = json['result']['os_type'].toString();
      osHostname.value = json['result']['os_hostname'].toString();
      hwCpuInfo.value = json['result']['hw_cpu_info'].toString();
      hwCpuCount.value = json['result']['hw_cpu_count'].toString();
      hwTotalMemory.value = json['result']['hw_total_memory'];
      hwUsedMemory.value = json['result']['hw_used_memory'];
      hwFreeMemory.value = json['result']['hw_free_memory'];
      jvmVendor.value = json['result']['jvm_vendor'].toString();
      jvmVersion.value = json['result']['jvm_version'].toString();
      jvmMaxHeapSize.value = json['result']['jvm_max_heap_size'];
      jvmTotalHeapSize.value = json['result']['jvm_total_heap_size'];
      jvmUsedHeapSize.value = json['result']['jvm_used_heap_size'];
    }
  }

  void callJvmGarbageCollector(BuildContext context) {
    developer.log('JVM Garbage Collector called');
    RestClient.rpc(RPC.jvmGc).then((value) => fetchSystemInformation());
    displaySuccess('CleanUp JVM Heap Space');
  }

  void callJvmRestart(BuildContext context) {
    developer.log('JVM restart called');
    RestClient.rpc(RPC.jvmRestart);
    displaySuccess('Restarting JVM, please wait ...');
  }
}
