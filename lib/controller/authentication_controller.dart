import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jos_ui/dialog/toast.dart';
import 'package:jos_ui/service/rest_client.dart';
import 'package:jos_ui/service/storage_service.dart';

class AuthenticationController extends GetxController {
  final TextEditingController usernameEditingController = TextEditingController();
  final TextEditingController passwordEditingController = TextEditingController();
  final TextEditingController captchaEditingController = TextEditingController();

  var captchaImage = Rxn<Image>();

  void login() async {
    developer.log('Login called');
    var success = await RestClient.login(usernameEditingController.text, passwordEditingController.text, captchaEditingController.text);
    if (success) {
      Get.offNamed('/dashboard');
    } else {
      displayError('Login failed');
      requestPublicKey();
    }
  }

  void logout() {
    developer.log('Logout called');
    StorageService.removeItem('token');
    Get.offAllNamed('/login');
  }

  Future<void> requestPublicKey() async {
    var result = await RestClient.sendEcdhPublicKey();
    if (result != null) {
      captchaImage.value = Image.memory(base64Decode(result));
    }
  }
}
