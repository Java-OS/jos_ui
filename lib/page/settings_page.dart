import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/backup_component.dart';
import 'package:jos_ui/component/basic_component.dart';
import 'package:jos_ui/component/date_time_component.dart';
import 'package:jos_ui/component/environment_component.dart';
import 'package:jos_ui/component/filesystem_component.dart';
import 'package:jos_ui/component/side_menu_component.dart';
import 'package:jos_ui/component/top_menu_component.dart';
import 'package:jos_ui/component/user_management_component.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/system_controller.dart';
import 'package:jos_ui/page_base_content.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SystemController _systemController = Get.put(SystemController());

  static final menuItems = [
    Icons.info_outline_rounded,
    Icons.date_range,
    Icons.join_right,
    Icons.groups_sharp,
    Icons.save,
    Icons.copy_sharp,
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getPageContent(
      child: Center(
        child: SizedBox(
          width: 600,
          height: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopMenuComponent(),
              SizedBox(height: 8),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SideMenuComponent(menuItems: menuItems, baseMenuPath: 'settings'),
                    chooseTargetTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget chooseTargetTab() {
    var tabIndex = Get.parameters['index'] ?? '0';
    switch (int.parse(tabIndex)) {
      case 0:
        return displayBasicSettings();
      case 1:
        return displayDateAndTimeContent();
      case 2:
        return displayEnvironmentsContent();
      case 3:
        return displayUserManagementContent();
      case 4:
        return displayFilesystemContent();
      case 5:
        return displayBackupSettings();
      default:
        return displayBasicSettings();
    }
  }

  Widget displayBasicSettings() {
    return basicContent(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Basic Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
          Divider(),
          BasicComponent(),
        ],
      ),
    );
  }

  Widget displayBackupSettings() {
    return basicContent(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Backup', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
          Divider(),
          BackupComponent(),
        ],
      ),
    );
  }

  Widget displayDateAndTimeContent() {
    return basicContent(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Date and Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
          Divider(),
          DateTimeComponent(),
        ],
      ),
    );
  }

  Widget displayUserManagementContent() {
    return basicContent(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Users', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
          Divider(),
          UserManagementComponent(),
        ],
      ),
    );
  }

  Widget displayEnvironmentsContent() {
    return basicContent(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Environment Variables', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
          Divider(),
          EnvironmentComponent(),
        ],
      ),
    );
  }

  Widget displayFilesystemContent() {
    return basicContent(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filesystem', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
              /* Refresh component [NO NOT MOVE THIS TO FilesystemComponent]*/
              OutlinedButton(onPressed: () => _systemController.fetchPartitions(), child: Icon(Icons.refresh_rounded, size: 16, color: Colors.black)),
            ],
          ),
          Divider(),
          FilesystemComponent(),
        ],
      ),
    );
  }

  Widget basicContent({child}) {
    return Expanded(
      child: Container(
        color: componentBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}
