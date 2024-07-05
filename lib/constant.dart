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
  settingBasic('/settings/basic'),
  settingsDateTime('/settings/datetime'),
  settingsEnvironments('/settings/env'),
  settingsUsers('/settings/user'),
  settingsFilesystem('/settings/filesystem'),
  settingsBackup('/settings/backup'),
  networkInterfaces('/network/interfaces'),
  networkNetworks('/network/networks'),
  networkHosts('/network/hosts'),
  modules('/modules');

  final String routeName;

  const Routes(this.routeName);
}
