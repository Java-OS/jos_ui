import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/text_field_box_widget.dart';
import 'package:jos_ui/controller/user_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/model/user.dart';
import 'package:jos_ui/utils.dart';

UserController _userController = Get.put(UserController());

Future<void> displayAddUser(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Add new user'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              TextFieldBox(controller: _userController.usernameEditingController, label: 'Username'),
              SizedBox(height: 8),
              TextFieldBox(controller: _userController.passwordEditingController, label: 'Password', isPassword: true),
              SizedBox(height: 8),
              TextFieldBox(controller: _userController.passwordConfirmationEditingController, label: 'Confirm password', isPassword: true),
              SizedBox(height: 8),
              Row(
                children: [
                  Text('Access bit ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Obx(() => Text('${_userController.realmBit.value}')),
                ],
              ),
              SizedBox(height: 8),
              Obx(() => realmTable()),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => _userController.addNewUser(),
                  child: Text('Apply'),
                ),
              )
            ],
          )
        ],
      );
    },
  );
}

Future<void> displayUpdatePassword(User user, BuildContext context) async {
  _userController.usernameEditingController.text = user.username;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Change password'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 33,
                color: Colors.grey[200],
                child: Center(
                  child: Text(
                    user.username,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextFieldBox(controller: _userController.passwordEditingController, label: 'Password', isPassword: true),
              SizedBox(height: 8),
              TextFieldBox(controller: _userController.passwordConfirmationEditingController, label: 'Confirm password', isPassword: true),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => _userController.updatePassword(),
                  child: Text('Apply'),
                ),
              )
            ],
          )
        ],
      );
    },
  );
}

Future<void> displayUpdateRoles(User user, BuildContext context) async {
  _userController.usernameEditingController.text = user.username;
  _userController.realmBit.value = user.realmBit;
  _userController.selectedRealms.value = ProtobufBitwiseUtils.getRealms(user.realmBit);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Change user realms'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 33,
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(user.username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(width: 8),
                    Obx(() => Text('${_userController.realmBit}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black45))),
                  ],
                ),
              ),
              Obx(() => realmTable()),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => _userController.updateUserRoles(),
                  child: Text('Apply'),
                ),
              )
            ],
          )
        ],
      );
    },
  );
}

Table realmTable() {
  var allRealms = Realm.values;
  var tableRows = <TableRow>[];
  for (var i = 0; i < allRealms.length; i++) {
    if (i % 2 == 0) {
      var row = TableRow(
        children: [
          Checkbox(value: _userController.isSelected(allRealms[i]!.value), onChanged: (e) => _userController.selectItem(allRealms[i]!, e!)),
          Text(allRealms[i]!.value.toString()),
          Checkbox(value: _userController.isSelected(allRealms[i + 1]!.value), onChanged: (e) => _userController.selectItem(allRealms[i + 1]!, e!)),
          Text(allRealms[i + 1]!.value.toString()),
        ],
      );

      tableRows.add(row);
    }
  }

  return Table(
    children: tableRows,
    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    defaultColumnWidth: IntrinsicColumnWidth(),
  );
}
