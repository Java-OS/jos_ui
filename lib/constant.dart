import 'package:flutter/material.dart';
import 'package:jos_ui/service/storage_service.dart';

/// Colors
const backgroundDarkColor = Color.fromRGBO(20, 44, 49, 1.0);

const secondaryColor = Color.fromRGBO(34, 76, 84, 1.0);
const dashboardMosaicBackgroundColor = Color.fromRGBO(80, 100, 80, 0.5);
final navigatorKey = GlobalKey<NavigatorState>();
final globalKey = GlobalKey();
const int chunkSize = 1024 * 1024; // 512 KB
String baseHandshakeUrl() => "${StorageService.getItem('server_ip_address') ?? 'http://127.0.0.1:7080'}/api/handshake";

String baseLoginUrl() => "${StorageService.getItem('server_ip_address') ?? 'http://127.0.0.1:7080'}/api/login";

String baseRpcUrl() => "${StorageService.getItem('server_ip_address') ?? 'http://127.0.0.1:7080'}/api/rpc";

String baseVerifyTokenUrl() => "${StorageService.getItem('server_ip_address') ?? 'http://127.0.0.1:7080'}/api/verify";

String baseUploadUrl() => "${StorageService.getItem('server_ip_address') ?? 'http://127.0.0.1:7080'}/api/upload";

String baseDownloadUrl() => "${StorageService.getItem('server_ip_address') ?? 'http://127.0.0.1:7080'}/api/download";

String baseEventWebSocketUrl() => "${StorageService.getItem('server_ip_address') ?? 'ws://127.0.0.1:7080'}/api/ws/events";

String baseJvmLogWebSocketUrl() => "${StorageService.getItem('server_ip_address') ?? 'ws://127.0.0.1:7080'}/api/ws/jvm-logs";

String baseContainerLogWebSocketUrl() => "${StorageService.getItem('server_ip_address') ?? 'ws://127.0.0.1:7080'}/api/ws/container-logs";

String baseContainerExecWebSocketUrl() => "${StorageService.getItem('server_ip_address') ?? 'ws://127.0.0.1:7080'}/api/ws/container-exec";

String baseKernelLogWebSocketUrl() => "${StorageService.getItem('server_ip_address') ?? 'ws://127.0.0.1:7080'}/api/ws/kmsg";

enum Routes {
  base('/'),
  login('/login'),
  logout('/logout'),
  dashboard('/dashboard'),
  oci('/oci/containers'),
  ociContainerCreate('/oci/container-create'),
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
  modules('/modules/module'),
  dependencies('/modules/dependencies'),
  moduleLogs('/modules/logs'),
  events('/events'),
  kernelLogs('/kernel-logs'),
  ;

  final String path;

  const Routes(this.path);

  static bool isExists(String path) {
    return Routes.values.any((e) => e.path == path);
  }
}
