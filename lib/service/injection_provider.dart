import 'package:get/get.dart';
import 'package:jos_ui/controller/authentication_controller.dart';
import 'package:jos_ui/controller/basic_controller.dart';
import 'package:jos_ui/controller/dashboard_controller.dart';
import 'package:jos_ui/controller/date_time_controller.dart';
import 'package:jos_ui/controller/environment_controller.dart';
import 'package:jos_ui/controller/jvm_controller.dart';
import 'package:jos_ui/controller/network_controller.dart';

class InjectionProvider {
  static void init() {
    Get.put(AuthenticationController());
    Get.put(BasicController());
    Get.put(DashboardController());
    Get.put(DateTimeController());
    Get.put(EnvironmentController());
    Get.put(JvmController());
    Get.put(NetworkController());
  }
}