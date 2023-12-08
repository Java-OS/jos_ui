import 'package:flutter/material.dart';
import 'package:jos_ui/component/basic_component.dart';
import 'package:jos_ui/component/date_time_component.dart';
import 'package:jos_ui/component/environment_component.dart';
import 'package:jos_ui/component/network_component.dart';
import 'package:jos_ui/component/side_menu_component.dart';
import 'package:jos_ui/component/top_menu_component.dart';
import 'package:jos_ui/component/user_management_component.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/page_base_content.dart';

class SettingPage extends StatefulWidget {
  final int tabIndex;

  const SettingPage({super.key, required this.tabIndex});

  @override
  State<SettingPage> createState() => _SystemPageState();
}

class _SystemPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return getPageContent(child: _pageContent());
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _pageContent() {
    return Center(
      child: SizedBox(
        width: 600,
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopMenuComponent(selectedIndex: 1),
            SizedBox(height: 8),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SideMenuComponent(indexTab: widget.tabIndex),
                  chooseTargetTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chooseTargetTab() {
    switch (widget.tabIndex) {
      case 0:
        return displayBasicSettings();
      case 1:
        return displayDateAndTimeContent();
      case 2:
        return displayEnvironmentsContent();
      case 3:
        return displayUserManagementContent();
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
