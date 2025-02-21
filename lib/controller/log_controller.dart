import 'dart:convert';
import 'dart:developer' as developer;

import 'package:fetch_client/fetch_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/toast.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/model/log.dart';
import 'package:jos_ui/model/log_info.dart';
import 'package:jos_ui/model/log_level.dart';
import 'package:jos_ui/service/api_service.dart';
import 'package:jos_ui/service/rest_client.dart';
import 'package:xterm/core.dart';
import 'package:xterm/ui.dart';

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
  final terminalController = TerminalController();
  final terminal = Terminal(maxLines: 1000, platform: TerminalTargetPlatform.web, reflowEnabled: true);
  var logAppenders = <LogInfo>[].obs;
  var isConnected = false.obs;
  var isTail = false.obs;
  var logLevel = LogLevel.all.obs;
  var systemLog = ''.obs;
  FetchResponse? fetchResponse;

  @override
  void onInit() {
    super.onInit();
    patternEditingController.text = '[%-5level] %date [%thread] %logger{10} [%file:%line] %msg%n';
  }

  Future<void> connect() async {
    if (packageEditingController.text.isEmpty) {
      developer.log('target package is empty');
      displayWarning('Target package is empty');
      return;
    }

    if (isConnected.isTrue) {
      developer.log('SSE already connected');
      disconnect(false, false);
    }
    var packageName = packageEditingController.text;
    var level = logLevel.value.name;
    developer.log('SSE controller try Connect $packageName $level');
    var content = {
      'message': {'package': packageName, 'level': level},
      'code': EventCode.JVM_LOGS.value
    };
    fetchResponse = await RestClient.sse(jsonEncode(content));
    isConnected.value = true;
    fetchResponse!.stream.where((event) => event.isNotEmpty).transform(const Utf8Decoder()).transform(const LineSplitter()).distinct().listen(
          (event) => writeToTerminal(event),
          cancelOnError: true,
          onError: (e) => developer.log(e),
        );
  }

  void writeToTerminal(String event) async {
    var log = Log.fromText(event);
    var formattedLog = '${log.dateTime} [${log.level}] ${log.logger} [${log.thread}] ${log.message}\r\n';
    terminal.write(formattedLog);
  }

  Future<void> disconnect(bool clearQueue, bool closeModal) async {
    if (clearQueue) {
      developer.log('Clear queue');
    }

    if (closeModal) {
      developer.log('Logger modal closed');
    }

    isTail.value = false;

    developer.log('Disconnect SSE');
    fetchResponse?.cancel();
    isConnected.value = false;
  }

  Future<void> changeLevel(LogLevel level) async {
    logLevel.value = level;
    if (isConnected.isTrue) connect();
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
