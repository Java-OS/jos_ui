import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';

class SettingsSideMenuComponent extends StatefulWidget {
  const SettingsSideMenuComponent({super.key});

  @override
  State<SettingsSideMenuComponent> createState() => _SettingsSideMenuComponentState();
}

class _SettingsSideMenuComponentState extends State<SettingsSideMenuComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        menuItem(Routes.settingBasic.routeName, Icons.info_outline_rounded),
        menuItem(Routes.settingsDateTime.routeName, Icons.date_range),
        menuItem(Routes.settingsEnvironments.routeName, Icons.join_right),
        menuItem(Routes.settingsUsers.routeName, Icons.groups_sharp),
        menuItem(Routes.settingsFilesystem.routeName, Icons.save),
        menuItem(Routes.settingsBackup.routeName, Icons.copy_sharp),
      ],
    );
  }

  Widget menuItem(String path, IconData icon) {
    var isOnRoute = Get.currentRoute == path;
    return InkWell(
      onTap: () => Get.offAllNamed(path),
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
}
