import 'package:flutter/material.dart';

/// Colors
const componentBackgroundColor = Color.fromRGBO(247, 247, 247, 1);
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
