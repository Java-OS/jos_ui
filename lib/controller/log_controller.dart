import 'dart:convert';
import 'dart:developer' as developer;

import 'package:fetch_client/fetch_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/model/event_code.dart';
import 'package:jos_ui/model/log.dart';
import 'package:jos_ui/model/log_info.dart';
import 'package:jos_ui/model/log_level.dart';
import 'package:jos_ui/protobuf/message-buffer.pb.dart';
import 'package:jos_ui/service/rest_client.dart';
import 'package:jos_ui/widget/toast.dart';

class LogController extends GetxController {
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
  var isConnected = false.obs;
  var isTail = false.obs;
  var logLevel = LogLevel.all.obs;
  var queue = <Log>[].obs;
  FetchResponse? fetchResponse;

  @override
  void onInit() {
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
      'message' :  {
        'package' : packageName,
        'level' : level
      },
      'code' : EventCode.jvmLogs.value
    };
    fetchResponse = await RestClient.sse(jsonEncode(content));
    isConnected.value = true;
    fetchResponse!.stream
        .transform(const Utf8Decoder())
        .transform(const LineSplitter())
        .where((event) => event.isNotEmpty)
        .listen((event) => addToQueue(event));
  }

  void addToQueue(String event) async {
    if (queue.length == 1000) {
      queue.removeAt(0);
    }
    queue.add(Log.fromText(event));
  }

  Future<void> disconnect(bool clearQueue, bool closeModal) async {
    if (clearQueue) {
      developer.log('Clear queue');
      queue.clear();
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
    var payload = await RestClient.rpc(RPC.RPC_LOG_APPENDER_LIST);
    if (payload.metadata.success) {
      var json = jsonDecode(payload.content);
      logAppenders.value = (json as List).map((e) => LogInfo.fromJson(e)).toList();
    } else {
      displayWarning('Failed to fetch log appenders');
    }
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
    var payload = await RestClient.rpc(RPC.RPC_LOG_APPENDER_ADD, parameters: reqParam);
    if (payload.metadata.success) {
      await fetchAppenders();
      Get.back();
      clear();
    } else {
      displayWarning('Failed to add log appender');
    }
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
    var payload = await RestClient.rpc(RPC.RPC_LOG_APPENDER_ADD, parameters: reqParam);
    if (payload.metadata.success) {
      await fetchAppenders();
      Get.back();
      clear();
    } else {
      displayWarning('Failed to add log appender');
    }
  }

  Future<void> removeAppender(int id) async {
    var reqParam = {'id': id};
    var payload = await RestClient.rpc(RPC.RPC_LOG_APPENDER_REMOVE, parameters: reqParam);
    if (payload.metadata.success) {
      await fetchAppenders();
      clear();
    } else {
      displayWarning('Failed to add log appender');
    }
  }

  void clear() {
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
