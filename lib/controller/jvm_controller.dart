import 'dart:developer' as developer;

import 'package:get/get.dart';
import 'package:jos_ui/controller/system_controller.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/service/rest_client.dart';
import 'package:jos_ui/widget/toast.dart';

class JvmController extends GetxController {
  final SystemController systemController = Get.put(SystemController());
  var blinkDelay = 1000.obs;
  var jvmNeedRestart = false.obs;

  void enableRestartJvm() {
    jvmNeedRestart.value = true;
  }

  void disableRestartJvm() {
    jvmNeedRestart.value = false;
  }

  void callJvmGarbageCollector() {
    developer.log('JVM Garbage Collector called');
    RestClient.rpc(Rpc.RPC_JVM_GC).then((value) => systemController.fetchSystemInformation());
    displaySuccess('CleanUp JVM Heap Space');
  }

  void callJvmRestart() {
    developer.log('JVM restart called');
    RestClient.rpc(Rpc.RPC_JVM_RESTART);
    disableRestartJvm();
    displaySuccess('Restarting JVM, please wait ...');
  }
}
