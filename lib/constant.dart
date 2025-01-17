import 'package:flutter/material.dart';

/// Colors
const backgroundDarkColor = Color.fromRGBO(20, 44, 49, 1.0);

const secondaryColor = Color.fromRGBO(34, 76, 84, 1.0);
const dashboardMosaicBackgroundColor = Color.fromRGBO(80, 100, 80, 0.5);
final navigatorKey = GlobalKey<NavigatorState>();
final globalKey = GlobalKey();

enum Routes {
  base('/', 'Login'),
  login('/login', 'LogIn'),
  logout('/logout', 'Logout'),
  dashboard('/dashboard', 'Dashboard'),
  oci('/oci', 'OCI'),
  ociContainers('/oci/containers', 'Containers'),
  ociImages('/oci/images', 'Images'),
  ociVolumes('/oci/volumes', 'Volumes'),
  ociNetworks('/oci/networks', 'Networks'),
  ociSettings('/oci/settings', 'Settings'),
  setting('/system', 'System Settings'),
  settingBasic('/system/basic', 'Basic'),
  settingKernelModules('/system/kernel-modules', 'Kernel Modules'),
  settingKernelParameters('/system/kernel-parameters', 'Kernel Parameters'),
  settingsDateTime('/system/datetime', 'Date & Time'),
  settingsEnvironments('/system/env', 'Environment Variables'),
  settingsUsers('/system/user', 'Users'),
  settingsBackup('/system/backup', 'Backup & Restore'),
  network('/network', 'Network'),
  networkInterfaces('/network/interfaces', 'Ethernets'),
  networkNetworks('/network/networks', 'Networks'),
  networkHosts('/network/hosts', 'Hosts'),
  firewall('/firewall', 'Firewall'),
  firewallTables('/firewall/tables', 'Tables'),
  firewallChains('/firewall/tables/chains', 'Chains'),
  filesystem('/filesystem', 'Filesystem'),
  modules('/modules', 'Modules');

  final String routeName;
  final String title;

  const Routes(this.routeName, this.title);

  static Routes find(String routeName) {
    return Routes.values.toList().firstWhere((e) => e.routeName == routeName);
  }
}
