import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/settings_side_menu_component.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/user_controller.dart';
import 'package:jos_ui/dialog/user_dialog.dart';
import 'package:jos_ui/page_base_content.dart';

class SettingsUserPage extends StatefulWidget {
  const SettingsUserPage({super.key});

  @override
  State<SettingsUserPage> createState() => _SettingsUserPageState();
}

class _SettingsUserPageState extends State<SettingsUserPage> {
  final _userController = Get.put(UserController());

  @override
  void initState() {
    _userController.fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getPageContent(
      child: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsSideMenuComponent(),
            Expanded(
              child: Container(
                color: componentBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Basic Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
                      Divider(),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            OutlinedButton(onPressed: () => displayAddUser(context), child: Icon(Icons.add, size: 16, color: Colors.black)),
                            SizedBox(width: 8),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Obx(() => DataTable(dataRowMinHeight: 12, dataRowMaxHeight: 28, columnSpacing: 10, columns: getUserTableColumns(), rows: getUserTableRows())),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<DataColumn> getUserTableColumns() {
    var idColumn = DataColumn(label: Text('id', style: TextStyle(fontWeight: FontWeight.bold)));
    var usernameColumn = DataColumn(label: Text('Username', style: TextStyle(fontWeight: FontWeight.bold)));
    var actionColumn = DataColumn(label: SizedBox.shrink());
    return [idColumn, usernameColumn, actionColumn];
  }

  List<DataRow> getUserTableRows() {
    final resultList = <DataRow>[];
    var users = _userController.userList;
    for (var i = 0; i < users.length; i++) {
      var user = users[i];
      var id = (i + 1).toString();
      var username = user.username.toString();
      var row = DataRow(cells: [
        DataCell(Text(id, style: TextStyle(fontSize: 12))),
        DataCell(Text(username, style: TextStyle(fontSize: 12))),
        DataCell(
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                IconButton(onPressed: username == 'admin' ? null : () => displayUpdateRoles(user, context), splashRadius: 14, splashColor: Colors.transparent, icon: Icon(Icons.security, size: 16)),
                IconButton(onPressed: username == 'admin' ? null : () => _userController.lockOrUnlockUser(user), splashRadius: 14, splashColor: Colors.transparent, icon: Icon(user.lock ? Icons.person_off_outlined : Icons.person, size: 16)),
                IconButton(onPressed: () => displayUpdatePassword(user, context), splashRadius: 14, splashColor: Colors.transparent, icon: Icon(Icons.password_outlined, size: 16)),
                IconButton(onPressed: username == 'admin' ? null : () => _userController.deleteUser(user), splashRadius: 14, splashColor: Colors.transparent, icon: Icon(Icons.delete_rounded, size: 16))
              ],
            ),
          ),
        ),
      ]);
      resultList.add(row);
    }

    return resultList;
  }
}
