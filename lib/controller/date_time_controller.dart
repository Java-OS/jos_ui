import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/dialog/toast.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/service/rpc_provider.dart';

class DateTimeController extends GetxController {
  final TextEditingController ntpServerEditingController = TextEditingController();
  final TextEditingController ntpIntervalEditingController = TextEditingController();

  var isNtpActive = false.obs;

  /* Server date & time*/
  var serverDate = ''.obs;
  var serverTime = ''.obs;

  /* NTP sync parameters */
  var leapIndicator = ''.obs;
  var version = ''.obs;
  var mode = ''.obs;
  var stratum = ''.obs;
  var poll = ''.obs;
  var precision = ''.obs;
  var rootDelay = ''.obs;
  var rootDispersion = ''.obs;
  var referenceIdentifier = ''.obs;
  var referenceTimestamp = ''.obs;
  var originateTimestamp = ''.obs;
  var receiveTimestamp = ''.obs;
  var transmitTimestamp = ''.obs;

  void fetchNtpInfo() async {
    developer.log('Fetch NTP Information called');
    var response = await RestClient.rpc(RPC.ntpInformation);
    if (response.result != null) {
      bool serverNtpIsActive = response.result['activate'];

      ntpServerEditingController.text = response.result['server'];
      ntpIntervalEditingController.text = response.result['interval'].toString();

      if (!serverNtpIsActive) {
        fetchSystemDateTime();
      } else {
        isNtpActive.value = serverNtpIsActive;
        syncNTP();
      }
    }
  }

  void fetchSystemDateTime() async {
    developer.log('Fetch system date time called');
    var result = await RestClient.rpc(RPC.dateTimeInformation);
    if (result.result != null) {
      serverDate.value = result.result['zonedDateTime'].split(' ')[0];
      serverTime.value = result.result['zonedDateTime'].split(' ')[1];
    }
  }

  void updateDateTime() {
    developer.log('Update date time called');
    String param = '$serverDate $serverTime';
    RestClient.rpc(RPC.systemSetDateTime, parameters: {'dateTime': param});
    displayInfo('System date & time updated');
  }

  Future<void> activateNtp() async {
    developer.log('Activate NTP called');
    await RestClient.rpc(RPC.ntpActivate, parameters: {'activate': isNtpActive.value});
    String activeMessage = 'NTP client activated';
    String disabledMessage = 'NTP client disabled';
    if (isNtpActive.value) displayInfo(isNtpActive.value ? activeMessage : disabledMessage);
  }

  Future<void> setNtpConfiguration() async {
    developer.log('Set NTP configuration called');
    var params = {'server': ntpServerEditingController.text, 'interval': int.parse(ntpIntervalEditingController.text)};
    await RestClient.rpc(RPC.ntpServerName, parameters: params);
    displayInfo('NTP configuration updated');
  }

  Future<void> syncNTP() async {
    developer.log('Sync NTP Called');
    var response = await RestClient.rpc(RPC.ntpSync);
    if (response.result != null) {
      leapIndicator.value = response.result['leapIndicator'].toString();
      version.value = response.result['version'].toString();
      mode.value = response.result['mode'].toString();
      stratum.value = response.result['stratum'].toString();
      poll.value = response.result['poll'].toString();
      precision.value = response.result['precision'].toString();
      rootDelay.value = response.result['rootDelay'].toString();
      rootDispersion.value = response.result['rootDispersion'].toString();
      referenceIdentifier.value = response.result['referenceIdentifier'].toString();
      referenceTimestamp.value = response.result['referenceTimestamp'].toString();
      originateTimestamp.value = response.result['originateTimestamp'].toString();
      receiveTimestamp.value = response.result['receiveTimestamp'].toString();
      transmitTimestamp.value = response.result['transmitTimestamp'].toString();
    }
  }

  Future<void> hcToSys() async {
    developer.log('Hardware clock to sys called');
    await RestClient.rpc(RPC.dateTimeSyncHctosys);
  }

  Future<void> sysToHc() async {
    developer.log('System to hardware clock called');
    await RestClient.rpc(RPC.dateTimeSyncSystohc);
  }

  void apply() async {
    if (isNtpActive.value) {
      activateNtp().then((value) => setNtpConfiguration()).then((value) => syncNTP());
    } else {
      activateNtp().then((value) => updateDateTime()).then((value) => fetchSystemDateTime());
    }
  }
}
