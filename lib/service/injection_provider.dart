import 'package:get/get.dart';
import 'package:jos_ui/controller/authentication_controller.dart';
import 'package:jos_ui/controller/date_time_controller.dart';
import 'package:jos_ui/controller/environment_controller.dart';
import 'package:jos_ui/controller/jvm_controller.dart';
import 'package:jos_ui/controller/module_controller.dart';
import 'package:jos_ui/controller/network_controller.dart';
import 'package:jos_ui/controller/log_controller.dart';
import 'package:jos_ui/controller/system_controller.dart';

class InjectionProvider {
  static void init() {
    Get.put(AuthenticationController());
    Get.put(SystemController());
    Get.put(SystemController());
    Get.put(DateTimeController());
    Get.put(EnvironmentController());
    Get.put(JvmController());
    Get.put(NetworkController());
    Get.put(ModuleController());
    Get.put(LogController());
  }
}
