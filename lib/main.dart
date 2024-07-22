import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/page/dashboard_page.dart';
import 'package:jos_ui/page/filesystem_page.dart';
import 'package:jos_ui/page/layout/responsive_layout.dart';
import 'package:jos_ui/page/login_page.dart';
import 'package:jos_ui/page/module_page.dart';
import 'package:jos_ui/page/network_hosts_page.dart';
import 'package:jos_ui/page/network_interfaces_page.dart';
import 'package:jos_ui/page/network_networks_page.dart';
import 'package:jos_ui/page/oci_containers_page.dart';
import 'package:jos_ui/page/oci_images_page.dart';
import 'package:jos_ui/page/oci_networks_page.dart';
import 'package:jos_ui/page/oci_settings_page.dart';
import 'package:jos_ui/page/oci_volumes_page.dart';
import 'package:jos_ui/page/settings_backup_page.dart';
import 'package:jos_ui/page/settings_basic_page.dart';
import 'package:jos_ui/page/settings_datetime_page.dart';
import 'package:jos_ui/page/settings_environments_page.dart';
import 'package:jos_ui/page/settings_kernel_modules_page.dart';
import 'package:jos_ui/page/settings_kernel_parameters_page.dart';
import 'package:jos_ui/page/settings_user_page.dart';
import 'package:timezone/data/latest.dart';
import 'package:toastification/toastification.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeTimeZones();
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
          fontFamily: 'cairo',
        ),
        debugShowCheckedModeBanner: false,
        title: 'JOS',
        initialRoute: Routes.base.routeName,
        navigatorKey: navigatorKey,
        getPages: [
          GetPage(name: Routes.base.routeName, page: () => LoginPage()),
          GetPage(name: Routes.login.routeName, page: () => LoginPage()),
          GetPage(name: Routes.dashboard.routeName, page: () => ResponsiveLayout(body: DashboardPage())),
          GetPage(name: Routes.settingBasic.routeName, page: () => ResponsiveLayout(body: SettingsBasicPage())),
          GetPage(name: Routes.settingKernelParameters.routeName, page: () => ResponsiveLayout(body: SettingsKernelParametersPage())),
          GetPage(name: Routes.settingKernelModules.routeName, page: () => ResponsiveLayout(body: SettingsKernelModulesPage())),
          GetPage(name: Routes.settingsDateTime.routeName, page: () => ResponsiveLayout(body: SettingsDatetimePage())),
          GetPage(name: Routes.settingsEnvironments.routeName, page: () => ResponsiveLayout(body: SettingsEnvironmentsPage())),
          GetPage(name: Routes.settingsUsers.routeName, page: () => ResponsiveLayout(body: SettingsUserPage())),
          GetPage(name: Routes.settingsBackup.routeName, page: () => ResponsiveLayout(body: SettingsBackupPage())),
          GetPage(name: Routes.networkInterfaces.routeName, page: () => ResponsiveLayout(body: NetworkInterfacesPage())),
          GetPage(name: Routes.networkNetworks.routeName, page: () => ResponsiveLayout(body: NetworkNetworksPage())),
          GetPage(name: Routes.networkHosts.routeName, page: () => ResponsiveLayout(body: NetworkHostsPage())),
          GetPage(name: Routes.filesystem.routeName, page: () => ResponsiveLayout(body: FilesystemPage())),
          GetPage(name: Routes.modules.routeName, page: () => ResponsiveLayout(body: ModulePage())),
          GetPage(name: Routes.ociContainers.routeName, page: () => ResponsiveLayout(body: OciContainersPage())),
          GetPage(name: Routes.ociImages.routeName, page: () => ResponsiveLayout(body: OciImagesPage())),
          GetPage(name: Routes.ociNetworks.routeName, page: () => ResponsiveLayout(body: OciNetworksPage())),
          GetPage(name: Routes.ociVolumes.routeName, page: () => ResponsiveLayout(body: OciVolumesPage())),
          GetPage(name: Routes.ociSettings.routeName, page: () => ResponsiveLayout(body: OciSettingsPage())),
        ],
      ),
    );
  }
}
