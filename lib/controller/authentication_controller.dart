import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jos_ui/modal/toast.dart';
import 'package:jos_ui/service/RpcProvider.dart';
import 'package:jos_ui/service/storage_service.dart';

class AuthenticationController extends GetxController {
  final TextEditingController usernameEditingController = TextEditingController();
  final TextEditingController passwordEditingController = TextEditingController();

  void login(BuildContext context) async {
    developer.log('Login called');
    var username = usernameEditingController.text;
    var password = passwordEditingController.text;
    var success = await RestClient.login(username, password);
    if (success) {
      Get.offAllNamed('/dashboard');
    } else {
      if (context.mounted) displayError('Login failed');
    }
  }

  void logout() {
    developer.log('Logout called');
    StorageService.removeItem('token');
    Get.toNamed('/');
  }

  void checkLogin() async {
    developer.log('Check Login called');
    var item = StorageService.getItem('token');
    if (item != null) {
      var isLogin = await RestClient.checkLogin();
      if (isLogin) {
        Get.toNamed('/dashboard');
      } else {
        StorageService.removeItem('token');
        Get.toNamed('/login');
      }
    } else {
      StorageService.removeItem('token');
      Get.toNamed('/login');
    }
  }
}
