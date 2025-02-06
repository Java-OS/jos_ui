import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jos_ui/dialog/alert_dialog.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/model/user.dart';
import 'package:jos_ui/service/api_service.dart';
import 'package:jos_ui/widget/toast.dart';

class UserController extends GetxController {
  final _apiService = Get.put(ApiService());
  final TextEditingController usernameEditingController = TextEditingController();
  final TextEditingController passwordEditingController = TextEditingController();
  final TextEditingController passwordConfirmationEditingController = TextEditingController();

  var userList = <User>[].obs;
  var realmBit = 0.obs;
  var lock = false.obs;
  var selectedRealms = <Realm>[].obs;

  List<User> getUsers() {
    return userList;
  }

  Future<void> fetchUsers() async {
    developer.log('Fetch users called');
    _apiService.callApi(Rpc.RPC_USER_LIST, message: 'Failed to fetch users').then((e) => e as List).then((list) => userList.value = list.map((e) => User.fromJson(e)).toList());
  }

  Future<void> addNewUser() async {
    var username = usernameEditingController.text;
    var password = passwordEditingController.text;
    var confirmedPassword = passwordConfirmationEditingController.text;

    if (password != confirmedPassword) {
      displayError('Password mismatch');
      return;
    }

    var reqParams = {'username': username, 'password': password, 'realmBit': realmBit.value};
    _apiService.callApi(Rpc.RPC_USER_ADD, parameters: reqParams, message: 'Failed to add user $username').then((e) => fetchUsers()).then((e) => Get.back()).then((e) => clean());
  }

  Future<void> updateUserRoles() async {
    var reqParams = {'username': usernameEditingController.text, 'realmBit': realmBit.value};
    _apiService.callApi(Rpc.RPC_USER_UPDATE_ROLE, parameters: reqParams, message: 'Failed to update roles of ${usernameEditingController.text}').then((e) => fetchUsers()).then((e) => Get.back()).then((e) => clean());
  }

  Future<void> updatePassword() async {
    var username = usernameEditingController.text;
    var password = passwordEditingController.text;
    var confirmedPassword = passwordConfirmationEditingController.text;

    if (password != confirmedPassword) {
      displayError('Password mismatch');
      return;
    }

    var reqParams = {'username': username, 'password': password};
    _apiService.callApi(Rpc.RPC_USER_PASSWD, parameters: reqParams, message: 'Failed to change password $username').then((e) => Get.back()).then((e) => clean());
  }

  Future<void> deleteUser(User user) async {
    if (user.username == 'admin') {
      displayError('Can not delete admin');
      return;
    }
    var isTrue = await displayAlertModal('Delete user', 'You want to delete user ${user.username}.\n\nAre you sure ?');
    if (isTrue) {
      var reqParams = {'username': user.username};
      _apiService.callApi(Rpc.RPC_USER_REMOVE, parameters: reqParams, message: 'Failed to delete user ${user.username}').then((e) => fetchUsers()).then((e) => Get.back()).then((e) => clean());
    }
  }

  Future<void> lockOrUnlockUser(User user) async {
    var reqParams = {'username': user.username};
    var lock = user.lock;
    _apiService.callApi(lock ? Rpc.RPC_USER_UNLOCK : Rpc.RPC_USER_LOCK, parameters: reqParams, message: lock ? 'Failed to activate ${user.username}' : 'Failed to disable ${user.username}').then((e) => fetchUsers()).then((e) => clean());
  }

  bool isSelected(int bit) {
    return selectedRealms.any((element) => element.value == bit);
  }

  void selectItem(Realm realm, bool add) {
    if (add) {
      selectedRealms.add(realm);
      realmBit += realm.value;
    } else {
      selectedRealms.remove(realm);
      realmBit -= realm.value;
    }
  }

  void clean() {
    usernameEditingController.clear();
    passwordEditingController.clear();
    passwordConfirmationEditingController.clear();
    selectedRealms.value = [];
    realmBit.value = 0;
  }
}
