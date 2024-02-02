import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jos_ui/dialog/toast.dart';
import 'package:jos_ui/service/rest_client.dart';
import 'package:jos_ui/service/storage_service.dart';

class AuthenticationController extends GetxController {
  final TextEditingController usernameEditingController = TextEditingController();
  final TextEditingController passwordEditingController = TextEditingController();

  void login() async {
    developer.log('Login called');
    var success = await RestClient.login(usernameEditingController.text, passwordEditingController.text);
    if (success) {
      Get.offNamed('/dashboard');
    } else {
      displayError('Login failed');
    }
  }

  void logout() {
    developer.log('Logout called');
    StorageService.removeItem('token');
    Get.offAllNamed('/login');
  }

  void checkLogin() async {
    developer.log('Check Login called');
    var tokenExists = StorageService.exists('token');
    if (tokenExists) {
      var isLogin = await RestClient.checkLogin();
      if (isLogin) {
        Get.offAllNamed('/dashboard');
      } else {
        StorageService.removeItem('token');
        Get.offAllNamed('/login');
      }
    } else {
      StorageService.removeItem('token');
      Get.offAllNamed('/login');
    }
  }
}
