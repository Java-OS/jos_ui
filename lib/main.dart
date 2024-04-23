import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/page/dashboard_page.dart';
import 'package:jos_ui/page/login_page.dart';
import 'package:jos_ui/page/module_page.dart';
import 'package:jos_ui/page/network/network_hosts_page.dart';
import 'package:jos_ui/page/network/network_interfaces_page.dart';
import 'package:jos_ui/page/network/network_networks_page.dart';
import 'package:jos_ui/page/settings/settings_backup_page.dart';
import 'package:jos_ui/page/settings/settings_basic_page.dart';
import 'package:jos_ui/page/settings/settings_datetime_page.dart';
import 'package:jos_ui/page/settings/settings_environment_page.dart';
import 'package:jos_ui/page/settings/settings_filesystem_page.dart';
import 'package:jos_ui/page/settings/settings_user_page.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(useMaterial3: false, fontFamily: 'Roboto'),
      debugShowCheckedModeBanner: false,
      title: 'JOS',
      initialRoute: '/',
      navigatorKey: navigatorKey,
      getPages: [
        GetPage(name: Routes.base.routeName, page: () => LoginPage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
        GetPage(name: Routes.login.routeName, page: () => LoginPage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
        GetPage(name: Routes.dashboard.routeName, page: () => DashboardPage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
        GetPage(name: Routes.settingBasic.routeName, page: () => SettingsBasicPage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
        GetPage(name: Routes.settingsDateTime.routeName, page: () => SettingsDateTimePage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
        GetPage(name: Routes.settingsEnvironments.routeName, page: () => SettingsEnvironmentPage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
        GetPage(name: Routes.settingsUsers.routeName, page: () => SettingsUserPage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
        GetPage(name: Routes.settingsFilesystem.routeName, page: () => SettingsFilesystemPage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
        GetPage(name: Routes.settingsBackup.routeName, page: () => SettingsBackupPage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
        GetPage(name: Routes.networkInterfaces.routeName, page: () => NetworkInterfacesPage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
        GetPage(name: Routes.networkNetworks.routeName, page: () => NetworkNetworksPage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
        GetPage(name: Routes.networkHosts.routeName, page: () => NetworkHostsPage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
        GetPage(name: Routes.modules.routeName, page: () => ModulePage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
      ],
    );
  }
}
