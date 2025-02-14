import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PanelDrawerController extends GetxController {

  var menuItems = [
    {'title': 'Dashboard', 'path': Routes.dashboard.path, 'icon': Icons.dashboard, 'font-size': 16, 'icon-size': 24},
    {'title': 'Modules', 'path': Routes.modules.path, 'icon': Icons.view_module, 'font-size': 16, 'icon-size': 24},
    {
      'title': 'OCI',
      'icon': MdiIcons.oci,
      'font-size': 16,
      'icon-size': 24,
      'path' : '/oci',
      'submenu': [
        {'title': 'Container', 'path': Routes.ociContainers.path, 'icon': MdiIcons.cubeOutline, 'font-size': 12, 'icon-size': 16},
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
      'path' : '/network',
      'submenu': [
        {'title': 'Interfaces', 'path': Routes.networkInterfaces.path, 'icon': Icons.info_outline, 'font-size': 12, 'icon-size': 16},
        {'title': 'Networks', 'path': Routes.networkNetworks.path, 'icon': Icons.hub_outlined, 'font-size': 12, 'icon-size': 16},
        {'title': 'Hosts', 'path': Routes.networkHosts.path, 'icon': Icons.devices_other_outlined, 'font-size': 12, 'icon-size': 16},
      ],
    },
    {'title': 'Firewall', 'path': Routes.firewallTables.path, 'icon': MdiIcons.wallFire, 'font-size': 16, 'icon-size': 24},
    {'title': 'Filesystem', 'path': Routes.filesystem.path, 'icon': Icons.save, 'font-size': 16, 'icon-size': 24},
    {
      'title': 'System',
      'icon': MdiIcons.cogs,
      'font-size': 16,
      'icon-size': 24,
      'path' : '/system',
      'submenu': [
        {'title': 'Basic', 'path': Routes.settingBasic.path, 'icon': Icons.settings, 'font-size': 12, 'icon-size': 16},
        {'title': 'Kernel Modules', 'path': Routes.settingKernelModules.path, 'icon': MdiIcons.cpu64Bit, 'font-size': 12, 'icon-size': 16},
        {'title': 'Kernel Parameters', 'path': Routes.settingKernelParameters.path, 'icon': MdiIcons.wrenchCogOutline, 'font-size': 12, 'icon-size': 16},
        {'title': 'Date & Time', 'path': Routes.settingsDateTime.path, 'icon': Icons.schedule, 'font-size': 12, 'icon-size': 16},
        {'title': 'Environment Variables', 'path': Routes.settingsEnvironments.path, 'icon': Icons.join_right, 'font-size': 12, 'icon-size': 16},
        {'title': 'Users', 'path': Routes.settingsUsers.path, 'icon': Icons.groups_sharp, 'font-size': 12, 'icon-size': 16},
        {'title': 'Backup', 'path': Routes.settingsBackup.path, 'icon': Icons.copy_sharp, 'font-size': 12, 'icon-size': 16},
      ],
    },
  ];

  var selectedItem = ''.obs;
  var submenuItem = ''.obs;
  var isSubmenu = false.obs;

  void routeTo(String? path) {
    selectedItem.value = path!;
    Get.offNamed(path);
  }

  bool isExpanded() {
    return selectedItem.value.startsWith(submenuItem);
  }
}