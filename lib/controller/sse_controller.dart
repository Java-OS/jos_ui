import 'dart:convert';
import 'dart:developer' as developer;

import 'package:fetch_client/fetch_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/dialog/toast.dart';
import 'package:jos_ui/model/log.dart';
import 'package:jos_ui/model/log_level.dart';
import 'package:jos_ui/service/rest_client.dart';

class SSEController extends GetxController {
  final TextEditingController packageEditingController = TextEditingController();

  var isConnected = false.obs;
  var isTail = false.obs;
  var logLevel = LogLevel.all.obs;
  var queue = <Log>[].obs;
  FetchResponse? fetchResponse;

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
    var level = logLevel.value;
    developer.log('SSE controller try Connect $packageName $level');
    fetchResponse = await RestClient.sse(packageName, level);
    isConnected.value = true;
    fetchResponse!.stream.transform(const Utf8Decoder()).transform(const LineSplitter()).where((event) => event.isNotEmpty).listen((event) => addToQueue(event));
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
      Get.back();
    }

    isTail.value = false;

    developer.log('Disconnect SSE');
    fetchResponse?.cancel();
    isConnected.value = false;
  }

  Future<void> changeLevel(LogLevel level) async {
    logLevel.value = level;
    connect();
  }
}
