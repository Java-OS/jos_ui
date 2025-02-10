import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

mixin Validator {
  var formKey = GlobalKey<FormState>();

  String? validateIpAddress(String? value) {
    return GetUtils.isIPv4(value!) ? null : 'Invalid ip address';
  }

  String? validatePortNumber(String? value) {
    return GetUtils.isNumericOnly(value!) ? null : 'Invalid port number';
  }

  String? validateOnlyEnglishCharacters(String? value) {
    return GetUtils.isAlphabetOnly(value!) ? null : 'Invalid port number';
  }
}
