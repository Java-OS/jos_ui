import 'package:flutter/material.dart';

/// Colors
const backgroundDarkColor =Color.fromRGBO(20, 44, 49, 1.0) ;
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
  settingBasic('/setting/basic'),
  settingKernelModules('/setting/kernel-modules'),
  settingKernelParameters('/setting/kernel-parameters'),
  settingsDateTime('/setting/datetime'),
  settingsEnvironments('/setting/env'),
  settingsUsers('/setting/user'),
  settingsFilesystem('/setting/filesystem'),
  settingsBackup('/setting/backup'),
  networkInterfaces('/network/interfaces'),
  networkNetworks('/network/networks'),
  networkHosts('/network/hosts'),
  filesystem('/filesystem'),
  modules('/modules');

  final String routeName;

  const Routes(this.routeName);
}
