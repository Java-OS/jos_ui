import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/page/dashboard_page.dart';
import 'package:jos_ui/page/filesystem_page.dart';
import 'package:jos_ui/page/layout/responsive_layout.dart';
import 'package:jos_ui/page/module_page.dart';
import 'package:jos_ui/page/network_hosts_page.dart';
import 'package:jos_ui/page/network_interfaces_page.dart';
import 'package:jos_ui/page/network_networks_page.dart';
import 'package:jos_ui/page/settings_backup_page.dart';
import 'package:jos_ui/page/settings_basic_page.dart';
import 'package:jos_ui/page/settings_datetime_page.dart';
import 'package:jos_ui/page/settings_environments_page.dart';
import 'package:jos_ui/page/settings_user_page.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:toastification/toastification.dart';

import 'page/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        theme: ThemeData(
          useMaterial3: false,
          outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(iconColor: Colors.black)),
          scaffoldBackgroundColor: Color(0xE8E4E4FF),
          datePickerTheme: DatePickerThemeData(headerBackgroundColor: Colors.green),
          drawerTheme: DrawerThemeData(
            elevation: 0,
            shape: Border(right: BorderSide(color: Colors.black12, width: 1)),
          ),
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            backgroundColor: Color(0xFAFAFAFA),
            shape: Border(bottom: BorderSide(color: Colors.black12, width: 1)),
          ),
          fontFamily: 'cairo'
        ),
        debugShowCheckedModeBanner: false,
        title: 'JOS',
        // home: ResponsiveLayout(
        //   body: Text('Hello'),
        // ),
        initialRoute: '/login',
        navigatorKey: navigatorKey,
        getPages: [
          GetPage(name: Routes.dashboard.routeName, page: () => ResponsiveLayout(body: DashboardPage()), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
          GetPage(name: '/login', page: () => LoginPage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
          // GetPage(name: '/dashboard', page: () => ResponsiveLayout(body: DashboardPage()), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
          GetPage(name: Routes.settingBasic.routeName, page: () => ResponsiveLayout(body: SettingsBasicPage()), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
          GetPage(name: Routes.settingsDateTime.routeName, page: () => ResponsiveLayout(body: SettingsDatetimePage()), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
          GetPage(name: Routes.settingsEnvironments.routeName, page: () => ResponsiveLayout(body: SettingsEnvironmentsPage()), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
          GetPage(name: Routes.settingsUsers.routeName, page: () => ResponsiveLayout(body: SettingsUserPage()), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
          GetPage(name: Routes.settingsBackup.routeName, page: () => ResponsiveLayout(body: SettingsBackupPage()), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
          GetPage(name: Routes.networkInterfaces.routeName, page: () => ResponsiveLayout(body: NetworkInterfacesPage()), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
          GetPage(name: Routes.networkNetworks.routeName, page: () => ResponsiveLayout(body: NetworkNetworksPage()), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
          GetPage(name: Routes.networkHosts.routeName, page: () => ResponsiveLayout(body: NetworkHostsPage()), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
          GetPage(name: Routes.filesystem.routeName, page: () => ResponsiveLayout(body: FilesystemPage()), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
          // GetPage(name: '/networks/:index', page: () => NetworkBasePage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
          GetPage(name: Routes.modules.routeName, page: () => ResponsiveLayout(body: ModulePage()), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
          // GetPage(name: '/containers/:index', page: () => ContainerBasePage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
        ],
      ),
    );
  }
}
