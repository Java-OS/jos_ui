import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:fluttericon/mfg_labs_icons.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PanelDrawerController extends GetxController {
  var menuItems = [
    {'title': 'Dashboard', 'path': Routes.dashboard.path, 'icon': Icons.dashboard, 'font-size': 16, 'icon-size': 24},
    {
      'title': 'Module',
      'icon': Icons.widgets,
      'font-size': 16,
      'icon-size': 24,
      'path': '/module',
      'submenu': [
        {'title': 'Modules', 'path': Routes.modules.path, 'icon': FontAwesome5.java, 'font-size': 12, 'icon-size': 16},
        {'title': 'Dependencies', 'path': Routes.dependencies.path, 'icon': LineariconsFree.layers, 'font-size': 12, 'icon-size': 16},
        {'title': 'Logs', 'path': Routes.moduleLogs.path, 'icon': ModernPictograms.article, 'font-size': 12, 'icon-size': 16},
      ],
    },
    {
      'title': 'OCI',
      'icon': MdiIcons.oci,
      'font-size': 16,
      'icon-size': 24,
      'path': '/oci',
      'submenu': [
        {'title': 'Container', 'path': Routes.oci.path, 'icon': MdiIcons.cubeOutline, 'font-size': 12, 'icon-size': 16},
        {'title': 'Image', 'path': Routes.ociImages.path, 'icon': MdiIcons.layersTriple, 'font-size': 12, 'icon-size': 16},
        {'title': 'Volume', 'path': Routes.ociVolumes.path, 'icon': MdiIcons.sd, 'font-size': 12, 'icon-size': 16},
        {'title': 'Network', 'path': Routes.ociNetworks.path, 'icon': MdiIcons.networkOutline, 'font-size': 12, 'icon-size': 16},
        {'title': 'Settings', 'path': Routes.ociSettings.path, 'icon': MdiIcons.cog, 'font-size': 12, 'icon-size': 16},
      ],
    },
    {
      'title': 'Network',
      'icon': Icons.lan_outlined,
      'font-size': 16,
      'icon-size': 24,
      'path': '/network',
      'submenu': [
        {'title': 'Interfaces', 'path': Routes.networkInterfaces.path, 'icon': FontAwesome5.ethernet, 'font-size': 12, 'icon-size': 16},
        {'title': 'Networks', 'path': Routes.networkNetworks.path, 'icon': Icons.hub_outlined, 'font-size': 12, 'icon-size': 16},
        {'title': 'Hosts', 'path': Routes.networkHosts.path, 'icon': Icons.devices_other_outlined, 'font-size': 12, 'icon-size': 16},
      ],
    },
    {'title': 'Firewall', 'path': Routes.firewallTables.path, 'icon': MdiIcons.wallFire, 'font-size': 16, 'icon-size': 24},
    {'title': 'Filesystem', 'path': Routes.filesystem.path, 'icon': MfgLabs.hdd, 'font-size': 16, 'icon-size': 24},
    {
      'title': 'System',
      'icon': MdiIcons.cogs,
      'font-size': 16,
      'icon-size': 24,
      'path': '/system',
      'submenu': [
        {'title': 'Basic', 'path': Routes.settingBasic.path, 'icon': Icons.settings, 'font-size': 12, 'icon-size': 16},
        {'title': 'Kernel Modules', 'path': Routes.settingKernelModules.path, 'icon': Typicons.puzzle, 'font-size': 12, 'icon-size': 16},
        {'title': 'Kernel Parameters', 'path': Routes.settingKernelParameters.path, 'icon': MdiIcons.wrenchCogOutline, 'font-size': 12, 'icon-size': 16},
        {'title': 'Date & Time', 'path': Routes.settingsDateTime.path, 'icon': Icons.schedule, 'font-size': 12, 'icon-size': 16},
        {'title': 'Environment Variables', 'path': Routes.settingsEnvironments.path, 'icon': Icons.join_right, 'font-size': 12, 'icon-size': 16},
        {'title': 'Users', 'path': Routes.settingsUsers.path, 'icon': Icons.groups_sharp, 'font-size': 12, 'icon-size': 16},
        {'title': 'Backup', 'path': Routes.settingsBackup.path, 'icon': Icons.copy_sharp, 'font-size': 12, 'icon-size': 16},
      ],
    },
    {'title': 'Events', 'path': Routes.events.path, 'icon': Icons.notifications_sharp, 'font-size': 16, 'icon-size': 24},
    {'title': 'Kernel Logs', 'path': Routes.kernelLogs.path, 'icon': FontAwesome5.microchip, 'font-size': 16, 'icon-size': 20},
  ];

  var selectedItem = ''.obs;
  var submenuItem = ''.obs;
  var isSubmenu = false.obs;

  void routeTo(String? path) {
    selectedItem.value = path!;
    if (Get.currentRoute == Routes.dashboard.path) {
      Get.offNamed(path);
    } else {
      Get.toNamed(path);
    }
  }

  bool isExpanded() {
    return selectedItem.value.startsWith(submenuItem);
  }
}
