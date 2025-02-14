import 'package:flutter/material.dart';

/// Colors
const backgroundDarkColor = Color.fromRGBO(20, 44, 49, 1.0);

const secondaryColor = Color.fromRGBO(34, 76, 84, 1.0);
const dashboardMosaicBackgroundColor = Color.fromRGBO(80, 100, 80, 0.5);
final navigatorKey = GlobalKey<NavigatorState>();
final globalKey = GlobalKey();

enum Routes {
  base('/'),
  login('/login'),
  logout('/logout'),
  dashboard('/dashboard'),
  ociContainers('/oci/containers'),
  ociImages('/oci/images'),
  ociVolumes('/oci/volumes'),
  ociNetworks('/oci/networks'),
  ociSettings('/oci/settings'),
  settingBasic('/system/basic'),
  settingKernelModules('/system/kernel-modules'),
  settingKernelParameters('/system/kernel-parameters'),
  settingsDateTime('/system/date-time'),
  settingsEnvironments('/system/environment-variable'),
  settingsUsers('/system/user'),
  settingsBackup('/system/backup-restore'),
  networkInterfaces('/network/interfaces'),
  networkNetworks('/network/networks'),
  networkHosts('/network/hosts'),
  firewallTables('/firewall'),
  firewallChains('/firewall/chains'),
  firewallRules('/firewall/chains/rules'),
  filesystem('/filesystem'),
  directoryTree('/filesystem/directory'),
  modules('/modules');

  final String path;

  const Routes(this.path);

  static bool isExists(String path) {
    return Routes.values.any((e) => e.path == path);
  }
}
