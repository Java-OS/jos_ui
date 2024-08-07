import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jos_ui/dialog/alert_dialog.dart';
import 'package:jos_ui/model/user.dart';
import 'package:jos_ui/protobuf/message-buffer.pb.dart';
import 'package:jos_ui/service/rest_client.dart';
import 'package:jos_ui/widget/toast.dart';

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
    var payload = await RestClient.rpc(RPC.RPC_USER_LIST);
    if (payload.metadata.success) {
      userList.value = (jsonDecode(payload.content) as List).map((e) => User.fromJson(e)).toList();
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
    var payload = await RestClient.rpc(RPC.RPC_USER_ADD, parameters: reqParams);
    if (payload.metadata.success) {
      await fetchUsers();
      Get.back();
      clear();
    } else {
      displayWarning('Failed to add user $username');
    }
  }

  Future<void> updateUserRoles() async {
    var reqParams = {'username': usernameEditingController.text, 'realmBit': realmBit.value};
    var payload = await RestClient.rpc(RPC.RPC_USER_UPDATE_ROLE, parameters: reqParams);
    if (payload.metadata.success) {
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
    var payload = await RestClient.rpc(RPC.RPC_USER_PASSWD, parameters: reqParams);
    if (payload.metadata.success) {
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
      var payload = await RestClient.rpc(RPC.RPC_USER_REMOVE, parameters: reqParams);
      if (payload.metadata.success) {
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
    var payload = await RestClient.rpc(lock ? RPC.RPC_USER_UNLOCK : RPC.RPC_USER_LOCK, parameters: reqParams);
    if (payload.metadata.success) {
      displaySuccess(lock ? 'User ${user.username} activated' : 'User ${user.username} disabled');
      await fetchUsers();
      clear();
      Get.back();
    } else {
      displayWarning(lock ? 'Failed to activate ${user.username}' : 'Failed to disable ${user.username}');
    }
  }

  bool isSelected(String name) {
    return selectedRealms.any((element) => element.name == name);
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

  void clear() {
    usernameEditingController.clear();
    passwordEditingController.clear();
    passwordConfirmationEditingController.clear();
    selectedRealms.value = [];
    realmBit.value = 0;
  }
}
