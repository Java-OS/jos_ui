import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/service/api_service.dart';
import 'package:jos_ui/widget/toast.dart';

class DateTimeController extends GetxController {
  final _apiService = Get.put(ApiService());
  final TextEditingController ntpServerEditingController = TextEditingController();
  final TextEditingController ntpIntervalEditingController = TextEditingController();
  final TextEditingController timeZoneEditingController = TextEditingController();

  var isNtpActive = false.obs;

  /* Server date & time*/
  var serverDate = ''.obs;
  var serverTime = ''.obs;
  var serverTimeZone = ''.obs;

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
    _apiService.callApi(Rpc.RPC_NTP_INFORMATION).then((map) {
      bool serverNtpIsActive = map['activate'];

      ntpServerEditingController.text = map['server'];
      ntpIntervalEditingController.text = map['interval'].toString();

      if (!serverNtpIsActive) {
        fetchSystemDateTime();
      } else {
        isNtpActive.value = serverNtpIsActive;
        syncNTP();
      }
    });
  }

  void fetchSystemDateTime() async {
    developer.log('Fetch system date time called');
    _apiService.callApi(Rpc.RPC_DATE_TIME_INFORMATION).then((map) {
      serverDate.value = map['zonedDateTime'].split(' ')[0];
      serverTime.value = map['zonedDateTime'].split(' ')[1];
      serverTimeZone.value = map['zonedDateTime'].split(' ')[2];
    });
  }

  void updateDateTime() {
    developer.log('Update date time called');
    String param = '$serverDate $serverTime';
    _apiService.callApi(Rpc.RPC_SYSTEM_SET_DATE_TIME, parameters: {'dateTime': param});
    displayInfo('System date & time updated');
  }

  Future<void> activateNtp() async {
    developer.log('Activate NTP called');
    _apiService.callApi(Rpc.RPC_NTP_ACTIVATE, parameters: {'activate': isNtpActive.value});
    String activeMessage = 'NTP client activated';
    String disabledMessage = 'NTP client disabled';
    if (isNtpActive.value) displayInfo(isNtpActive.value ? activeMessage : disabledMessage);
  }

  Future<void> setNtpConfiguration() async {
    developer.log('Set NTP configuration called');
    var params = {'server': ntpServerEditingController.text, 'interval': int.parse(ntpIntervalEditingController.text)};
    _apiService.callApi(Rpc.RPC_NTP_SERVER_NAME, parameters: params);
    displayInfo('NTP configuration updated');
  }

  Future<void> syncNTP() async {
    developer.log('Sync NTP Called');
    _apiService.callApi(Rpc.RPC_NTP_SYNC).then((map) {
      leapIndicator.value = map['leapIndicator'].toString();
      version.value = map['version'].toString();
      mode.value = map['mode'].toString();
      stratum.value = map['stratum'].toString();
      poll.value = map['poll'].toString();
      precision.value = map['precision'].toString();
      rootDelay.value = map['rootDelay'].toString();
      rootDispersion.value = map['rootDispersion'].toString();
      referenceIdentifier.value = map['referenceIdentifier'].toString();
      referenceTimestamp.value = map['referenceTimestamp'].toString();
      originateTimestamp.value = map['originateTimestamp'].toString();
      receiveTimestamp.value = map['receiveTimestamp'].toString();
      transmitTimestamp.value = map['transmitTimestamp'].toString();
    });
  }

  Future<void> hcToSys() async {
    developer.log('Hardware clock to sys called');
    _apiService.callApi(Rpc.RPC_DATE_TIME_SYNC_HCTOSYS);
  }

  Future<void> sysToHc() async {
    developer.log('System to hardware clock called');
    _apiService.callApi(Rpc.RPC_DATE_TIME_SYNC_SYSTOHC);
  }

  void apply() async {
    if (isNtpActive.value) {
      activateNtp().then((value) => setNtpConfiguration()).then((value) => syncNTP());
    } else {
      activateNtp().then((value) => updateDateTime()).then((value) => fetchSystemDateTime());
    }
  }

  Future<void> updateTimezone(String zone) async {
    var reqParam = {'timezone': zone.split('\t')[0]};
    _apiService.callApi(Rpc.RPC_SYSTEM_SET_TIMEZONE, parameters: reqParam).then((e) {
      displayInfo('Timezone successfully updated');
      if (isNtpActive.isTrue) {
        fetchNtpInfo();
      }
    });
  }
}
