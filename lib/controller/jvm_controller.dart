import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JvmController extends GetxController {
  var blinkDelay = 1000.obs;
  var jvmNeedRestart = false.obs;

  void enableRestartJvm() {
    jvmNeedRestart.value = true;
  }

  void disableRestartJvm() {
    jvmNeedRestart.value = false;
  }
}
