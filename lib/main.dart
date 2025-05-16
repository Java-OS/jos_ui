import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/page/dashboard_page.dart';
import 'package:jos_ui/page/event_page.dart';
import 'package:jos_ui/page/filesystem_page.dart';
import 'package:jos_ui/page/firewall/firewall_chain_page.dart';
import 'package:jos_ui/page/firewall/firewall_rule_page.dart';
import 'package:jos_ui/page/firewall/firewall_table_page.dart';
import 'package:jos_ui/page/kernel_log_page.dart';
import 'package:jos_ui/page/module/dependency_page.dart';
import 'package:jos_ui/page/module/module_log_page.dart';
import 'package:jos_ui/page/layout/responsive_layout.dart';
import 'package:jos_ui/page/loading_page.dart';
import 'package:jos_ui/page/login_page.dart';
import 'package:jos_ui/page/module/module_page.dart';
import 'package:jos_ui/page/network/network_hosts_page.dart';
import 'package:jos_ui/page/network/network_interfaces_page.dart';
import 'package:jos_ui/page/network/network_networks_page.dart';
import 'package:jos_ui/page/oci/oci_container_create_page.dart';
import 'package:jos_ui/page/oci/oci_container_list_page.dart';
import 'package:jos_ui/page/oci/oci_images_page.dart';
import 'package:jos_ui/page/oci/oci_networks_page.dart';
import 'package:jos_ui/page/oci/oci_image_search_page.dart';
import 'package:jos_ui/page/oci/oci_settings_page.dart';
import 'package:jos_ui/page/oci/oci_volumes_files_page.dart';
import 'package:jos_ui/page/oci/oci_volumes_page.dart';
import 'package:jos_ui/page/settings/settings_backup_page.dart';
import 'package:jos_ui/page/settings/settings_basic_page.dart';
import 'package:jos_ui/page/settings/settings_datetime_page.dart';
import 'package:jos_ui/page/settings/settings_environments_page.dart';
import 'package:jos_ui/page/settings/settings_kernel_modules_page.dart';
import 'package:jos_ui/page/settings/settings_kernel_parameters_page.dart';
import 'package:jos_ui/page/settings/settings_user_page.dart';
import 'package:timezone/data/latest.dart';
import 'package:toastification/toastification.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BrowserContextMenu.disableContextMenu();
  initializeTimeZones();
  runApp(const JosApplication());
}

class JosApplication extends StatelessWidget {
  const JosApplication({super.key});

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
        initialRoute: Routes.base.path,
        navigatorKey: navigatorKey,
        getPages: [
          GetPage(name: Routes.base.path, transitionDuration: Duration.zero, page: () => LoadingPage()),
          GetPage(name: Routes.login.path, transitionDuration: Duration.zero, page: () => LoginPage()),
          GetPage(name: Routes.dashboard.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: DashboardPage())),
          GetPage(name: Routes.settingBasic.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: SettingsBasicPage())),
          GetPage(name: Routes.settingKernelParameters.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: SettingsKernelParametersPage())),
          GetPage(name: Routes.settingKernelModules.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: SettingsKernelModulesPage())),
          GetPage(name: Routes.settingsDateTime.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: SettingsDatetimePage())),
          GetPage(name: Routes.settingsEnvironments.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: SettingsEnvironmentsPage())),
          GetPage(name: Routes.settingsUsers.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: SettingsUserPage())),
          GetPage(name: Routes.settingsBackup.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: SettingsBackupPage())),
          GetPage(name: Routes.networkInterfaces.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: NetworkInterfacesPage())),
          GetPage(name: Routes.networkNetworks.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: NetworkNetworksPage())),
          GetPage(name: Routes.networkHosts.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: NetworkHostsPage())),
          GetPage(name: Routes.firewallTables.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: FirewallTablePage())),
          GetPage(name: Routes.firewallChains.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: FirewallChainPage())),
          GetPage(name: Routes.firewallRules.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: FirewallRulePage())),
          GetPage(name: Routes.filesystem.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: FilesystemPage())),
          GetPage(name: Routes.modules.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: ModulePage())),
          GetPage(name: Routes.dependencies.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: DependencyPage())),
          GetPage(name: Routes.moduleLogs.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: ModuleLogPage())),
          GetPage(name: Routes.oci.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: OciContainerListPage())),
          GetPage(name: Routes.ociContainerCreate.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: OciContainerCreatePage())),
          GetPage(name: Routes.ociImages.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: OciImagesPage())),
          GetPage(name: Routes.ociNetworks.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: OciNetworksPage())),
          GetPage(name: Routes.ociVolumes.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: OciVolumesPage())),
          GetPage(name: Routes.ociVolumesFiles.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: OciVolumesFilesPage())),
          GetPage(name: Routes.ociSettings.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: OciSettingsPage())),
          GetPage(name: Routes.ociImageSearch.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: OciImageSearchPage())),
          GetPage(name: Routes.events.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: EventPage())),
          GetPage(name: Routes.kernelLogs.path, transitionDuration: Duration.zero, page: () => ResponsiveLayout(body: KernelLogPage())),
        ],
      ),
    );
  }
}
