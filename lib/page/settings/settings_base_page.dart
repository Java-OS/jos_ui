import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/page/settings/tab_backup.dart';
import 'package:jos_ui/page/settings/tab_basic.dart';
import 'package:jos_ui/page/settings/tab_datetime.dart';
import 'package:jos_ui/page/settings/tab_environment.dart';
import 'package:jos_ui/page/settings/tab_filesystem.dart';
import 'package:jos_ui/page/settings/tab_user.dart';
import 'package:jos_ui/component/page_layout.dart';

class SettingsBasePage extends StatefulWidget {
  const SettingsBasePage({super.key});

  @override
  State<SettingsBasePage> createState() => _SettingsBasePageState();
}

class _SettingsBasePageState extends State<SettingsBasePage> {
  static const baseRoute = '/settings';

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              sideMenu(0, Icons.info_outline_rounded),
              sideMenu(1, Icons.date_range),
              sideMenu(2, Icons.join_right),
              sideMenu(3, Icons.groups_sharp),
              sideMenu(4, Icons.save),
              sideMenu(5, Icons.copy_sharp),
            ],
          ),
          tabContent(),
        ],
      ),
    );
  }

  Widget tabContent() {
    return Expanded(
      child: Container(
        height: 380,
        color: componentBackgroundColor,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: chooseTargetTab(),
        ),
      ),
    );
  }

  Widget sideMenu(int tabIndex, IconData icon) {
    var reqIndex = int.parse(Get.parameters['index'] ?? '0');
    var isOnRoute = reqIndex == tabIndex;
    return InkWell(
      onTap: () => Get.toNamed('$baseRoute/$tabIndex'),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2.0),
        child: AnimatedContainer(
          decoration: BoxDecoration(
            color: isOnRoute ? componentBackgroundColor : Colors.white10,
          ),
          width: 80,
          height: 50,
          duration: Duration(milliseconds: 200),
          child: Center(
            child: Icon(icon, size: 22, color: isOnRoute ? Colors.blue : Colors.white38),
          ),
        ),
      ),
    );
  }

  Widget chooseTargetTab() {
    var tabIndex = Get.parameters['index'] ?? '0';
    switch (int.parse(tabIndex)) {
      case 0:
        return TabBasic();
      case 1:
        return TabDateTime();
      case 2:
        return TabEnvironments();
      case 3:
        return TabUsers();
      case 4:
        return TabFilesystem();
      case 5:
        return TabBackup();
      default:
        return TabBasic();
    }
  }
}
