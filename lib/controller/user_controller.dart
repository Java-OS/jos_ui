import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jos_ui/dialog/alert_dialog.dart';
import 'package:jos_ui/dialog/toast.dart';
import 'package:jos_ui/model/realm.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/model/user.dart';
import 'package:jos_ui/service/rpc_provider.dart';

class UserController extends GetxController {
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
    var response = await RestClient.rpc(RPC.userList);
    if (response.success) {
      userList.value = (response.result as List).map((e) => User.fromJson(e)).toList();
    } else {
      displayWarning('Failed to fetch users');
    }
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
    var response = await RestClient.rpc(RPC.userAdd, parameters: reqParams);
    if (response.success) {
      await fetchUsers();
      Get.back();
      clear();
    } else {
      displayWarning('Failed to add user $username');
    }
  }

  Future<void> updateUserRoles() async {
    var reqParams = {'username': usernameEditingController.text, 'realmBit': realmBit.value};
    var response = await RestClient.rpc(RPC.userUpdateRole, parameters: reqParams);
    if (response.success) {
      await fetchUsers();
      clear();
      Get.back();
    } else {
      displayWarning('Failed to update roles of ${usernameEditingController.text}');
    }
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
    var response = await RestClient.rpc(RPC.userPasswd, parameters: reqParams);
    if (response.success) {
      Get.back();
      clear();
    } else {
      displayWarning('Failed to change password $username');
    }
  }

  Future<void> deleteUser(User user) async {
    if (user.username == 'admin') {
      displayError('Can not delete admin');
      return;
    }
    var isTrue = await displayAlertModal('Delete user', 'You want to delete user ${user.username}.\n\nAre you sure ?');
    if (isTrue) {
      var reqParams = {'username': user.username};
      var response = await RestClient.rpc(RPC.userRemove, parameters: reqParams);
      if (response.success) {
        await fetchUsers();
        clear();
        Get.back();
      } else {
        displayWarning('Failed to delete user ${user.username}');
      }
    }
  }

  Future<void> lockOrUnlockUser(User user) async {
    var reqParams = {'username': user.username};
    var lock = user.lock;
    var response = await RestClient.rpc(lock ? RPC.userUnlock : RPC.userLock, parameters: reqParams);
    if (response.success) {
      displaySuccess(lock ? 'User ${user.username} unlocked' : 'User ${user.username} locked');
      await fetchUsers();
      clear();
      Get.back();
    } else {
      displayWarning(lock ? 'Failed to unlock ${user.username}' : 'Failed to lock ${user.username}');
    }
  }

  bool isSelected(String name) {
    return selectedRealms.any((element) => element.name == name);
  }

  void selectItem(Realm realm, bool add) {
    if (add) {
      selectedRealms.add(realm);
      realmBit += realm.getBit();
    } else {
      selectedRealms.remove(realm);
      realmBit -= realm.getBit();
    }
  }

  void clear() {
    usernameEditingController.clear();
    passwordEditingController.clear();
    passwordConfirmationEditingController.clear();
    selectedRealms.value = [];
    realmBit.value = 0;
  }
}
