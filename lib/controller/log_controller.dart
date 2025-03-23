import 'package:fetch_client/fetch_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/model/log_info.dart';
import 'package:jos_ui/model/log_level.dart';
import 'package:jos_ui/service/api_service.dart';

class LogController extends GetxController {
  final _apiService = Get.put(ApiService());
  final TextEditingController idEditingController = TextEditingController();
  final TextEditingController packageEditingController = TextEditingController();
  final TextEditingController patternEditingController = TextEditingController();
  final TextEditingController typeEditingController = TextEditingController();
  final TextEditingController syslogHostEditingController = TextEditingController();
  final TextEditingController syslogPortEditingController = TextEditingController();
  final TextEditingController syslogFacilityEditingController = TextEditingController();
  final TextEditingController fileMaxSizeEditingController = TextEditingController();
  final TextEditingController fileTotalSizeEditingController = TextEditingController();
  final TextEditingController fileMaxHistoryEditingController = TextEditingController();

  var logAppenders = <LogInfo>[].obs;
  var isTail = false.obs;
  var logLevel = LogLevel.all.obs;
  var systemLog = ''.obs;
  FetchResponse? fetchResponse;

  @override
  void onInit() {
    super.onInit();
    patternEditingController.text = '[%-5level] %date [%thread] %logger{10} [%file:%line] %msg%n';
  }

  Future<void> fetchAppenders() async {
    _apiService.callApi(Rpc.RPC_LOG_APPENDER_LIST, message: 'Failed to fetch log appenders').then((e) => e as List).then((e) => logAppenders.value = e.map((e) => LogInfo.fromMap(e)).toList());
  }

  Future<void> addFileAppender() async {
    var reqParam = {
      'id': idEditingController.text.isEmpty ? null : int.parse(idEditingController.text),
      'type': 'FILE',
      'packageName': packageEditingController.text,
      'pattern': patternEditingController.text,
      'level': logLevel.value.name.toUpperCase(),
      'fileMaxSize': int.parse(fileMaxSizeEditingController.text),
      'fileTotalSize': int.parse(fileTotalSizeEditingController.text),
      'fileMaxHistory': int.parse(fileMaxHistoryEditingController.text),
    };
    _apiService.callApi(Rpc.RPC_LOG_APPENDER_ADD, parameters: reqParam, message: 'Failed to add log appender').then((e) => fetchAppenders()).then((e) => Get.back()).then((e) => clean());
  }

  Future<void> addSyslogAppender() async {
    var reqParam = {
      'id': idEditingController.text.isEmpty ? null : int.parse(idEditingController.text),
      'type': 'SYSLOG',
      'packageName': packageEditingController.text,
      'pattern': patternEditingController.text,
      'level': logLevel.value.name.toUpperCase(),
      'syslogHost': syslogHostEditingController.text,
      'syslogPort': int.parse(syslogPortEditingController.text),
      'syslogFacility': syslogFacilityEditingController.text,
    };
    _apiService.callApi(Rpc.RPC_LOG_APPENDER_ADD, parameters: reqParam, message: 'Failed to add log appender').then((e) => fetchAppenders()).then((e) => Get.back()).then((e) => clean());
  }

  Future<void> removeAppender(int id) async {
    var reqParam = {'id': id};
    _apiService.callApi(Rpc.RPC_LOG_APPENDER_REMOVE, parameters: reqParam, message: 'Failed to add log appender').then((e) => fetchAppenders()).then((e) => clean());
  }

  Future<void> fetchSystemLog() async {
    _apiService.callApi(Rpc.RPC_LOG_SYSTEM).then((map) {
      for (var value in map) {
        systemLog.value += '$value\n';
      }
    });
  }

  void clean() {
    packageEditingController.clear();
    typeEditingController.clear();
    syslogHostEditingController.clear();
    syslogPortEditingController.clear();
    syslogFacilityEditingController.clear();
    fileMaxSizeEditingController.clear();
    fileTotalSizeEditingController.clear();
    fileMaxHistoryEditingController.clear();
  }
}
