import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PanelDrawerController extends GetxController {

  var menuItems = [
    {'title': 'Dashboard', 'path': Routes.dashboard.routeName, 'icon': Icons.dashboard, 'font-size': 16, 'icon-size': 24},
    {'title': 'Modules', 'path': Routes.modules.routeName, 'icon': Icons.view_module, 'font-size': 16, 'icon-size': 24},
    {
      'title': 'OCI',
      'icon': MdiIcons.oci,
      'font-size': 16,
      'icon-size': 24,
      'path' : '/oci',
      'submenu': [
        {'title': 'Containers', 'path': Routes.ociContainers.routeName, 'icon': MdiIcons.cubeOutline, 'font-size': 12, 'icon-size': 16},
        {'title': 'Images', 'path': Routes.ociImages.routeName, 'icon': MdiIcons.layersTriple, 'font-size': 12, 'icon-size': 16},
        {'title': 'Volumes', 'path': Routes.ociVolumes.routeName, 'icon': MdiIcons.sd, 'font-size': 12, 'icon-size': 16},
        {'title': 'Networks', 'path': Routes.ociNetworks.routeName, 'icon': MdiIcons.networkOutline, 'font-size': 12, 'icon-size': 16},
        {'title': 'Settings', 'path': Routes.ociSettings.routeName, 'icon': MdiIcons.cog, 'font-size': 12, 'icon-size': 16},
      ],
    },
    {
      'title': 'Networks',
      'icon': Icons.lan_outlined,
      'font-size': 16,
      'icon-size': 24,
      'path' : '/network',
      'submenu': [
        {'title': 'Interfaces', 'path': Routes.networkInterfaces.routeName, 'icon': Icons.info_outline, 'font-size': 12, 'icon-size': 16},
        {'title': 'Networks', 'path': Routes.networkNetworks.routeName, 'icon': Icons.hub_outlined, 'font-size': 12, 'icon-size': 16},
        {'title': 'Hosts', 'path': Routes.networkHosts.routeName, 'icon': Icons.devices_other_outlined, 'font-size': 12, 'icon-size': 16},
      ],
    },
    {'title': 'Firewall', 'path': Routes.filesystem.routeName, 'icon': MdiIcons.wallFire, 'font-size': 16, 'icon-size': 24},
    {'title': 'Filesystem', 'path': Routes.filesystem.routeName, 'icon': Icons.save, 'font-size': 16, 'icon-size': 24},
    {
      'title': 'Settings',
      'icon': MdiIcons.cogs,
      'font-size': 16,
      'icon-size': 24,
      'path' : '/setting',
      'submenu': [
        {'title': 'Basic', 'path': Routes.settingBasic.routeName, 'icon': Icons.settings, 'font-size': 12, 'icon-size': 16},
        {'title': 'Kernel Modules', 'path': Routes.settingKernelModules.routeName, 'icon': MdiIcons.cpu64Bit, 'font-size': 12, 'icon-size': 16},
        {'title': 'Kernel Parameters', 'path': Routes.settingKernelParameters.routeName, 'icon': MdiIcons.wrenchCogOutline, 'font-size': 12, 'icon-size': 16},
        {'title': 'Date & Time', 'path': Routes.settingsDateTime.routeName, 'icon': Icons.schedule, 'font-size': 12, 'icon-size': 16},
        {'title': 'Environment Variables', 'path': Routes.settingsEnvironments.routeName, 'icon': Icons.join_right, 'font-size': 12, 'icon-size': 16},
        {'title': 'Users', 'path': Routes.settingsUsers.routeName, 'icon': Icons.groups_sharp, 'font-size': 12, 'icon-size': 16},
        {'title': 'Backup', 'path': Routes.settingsBackup.routeName, 'icon': Icons.copy_sharp, 'font-size': 12, 'icon-size': 16},
      ],
    },
  ];

  var selectedItem = ''.obs;
  var submenuItem = ''.obs;
  var isSubmenu = false.obs;

  void routeTo(String? path) {
    selectedItem.value = path!;
    Get.toNamed(path);
  }

  bool isExpanded() {
    return selectedItem.value.startsWith(submenuItem);
  }
}