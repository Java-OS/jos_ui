import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DrawerComponent extends StatefulWidget {
  const DrawerComponent({super.key});

  @override
  State<DrawerComponent> createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  var _selectedItem = '/dashboard';

  var menuItems = [
    {'title': 'Dashboard', 'path': '/dashboard', 'icon': Icons.dashboard, 'font-size': 16, 'icon-size': 24},
    {'title': 'Modules', 'path': '/modules', 'icon': Icons.view_module, 'font-size': 16, 'icon-size': 24},
    {
      'title': 'OCI',
      'path': '/oci',
      'icon': MdiIcons.oci,
      'font-size': 16,
      'icon-size': 24,
      'submenu': [
        {'title': 'Containers', 'path': '/oci/containers', 'icon': MdiIcons.cubeOutline, 'font-size': 12, 'icon-size': 16},
        {'title': 'Images', 'path': '/oci/images', 'icon': MdiIcons.layersTriple, 'font-size': 12, 'icon-size': 16},
        {'title': 'Volumes', 'path': '/oci/volumes', 'icon': MdiIcons.sd, 'font-size': 12, 'icon-size': 16},
        {'title': 'Networks', 'path': '/oci/networks', 'icon': MdiIcons.networkOutline, 'font-size': 12, 'icon-size': 16},
        {'title': 'Settings', 'path': '/oci/settings', 'icon': MdiIcons.cog, 'font-size': 12, 'icon-size': 16},
      ],
    },
    {'title': 'Networks', 'path': '/networks', 'icon': Icons.lan_outlined, 'font-size': 16, 'icon-size': 24},
    {
      'title': 'Settings',
      'path': '/settings',
      'icon': Icons.settings,
      'font-size': 16,
      'icon-size': 24,
      'submenu': [
        {'title': 'Basic', 'path': '/settings/basic', 'icon': Icons.settings, 'font-size': 12, 'icon-size': 16},
        {'title': 'Date & Time', 'path': '/settings/date-time', 'icon': Icons.info_outline_rounded, 'font-size': 12, 'icon-size': 16},
        {'title': 'Environment Variables', 'path': '/settings/environments', 'icon': Icons.join_right, 'font-size': 12, 'icon-size': 16},
        {'title': 'Users', 'path': '/settings/users', 'icon': Icons.groups_sharp, 'font-size': 12, 'icon-size': 16},
        {'title': 'Backup', 'path': '/settings/backup', 'icon': Icons.copy_sharp, 'font-size': 12, 'icon-size': 16},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    var menuList = buildList(menuItems, false);
    menuList.insert(0, drawerHeader());
    return Drawer(
      child: ListView(
        children: menuList,
      ),
    );
  }

  Color itemColor(path) => path == _selectedItem ? Colors.white : Colors.grey;

  List<Widget> buildList(List<Map<String, Object>> items, bool isSubmenu) {
    var list = <Widget>[];
    for (var item in items) {
      var title = item['title'] as String;
      var path = item['path'] as String;
      var icon = item['icon'] as IconData;
      var fontSize = item['font-size'] as double;
      var iconSize = item['icon-size'] as double;
      var submenu = item['submenu'];
      if (submenu != null) {
        var tile = ExpansionTile(
          leading: Icon(icon, color: Colors.grey),
          title: Text(title, style: TextStyle(color: Colors.grey)),
          children: buildList(submenu as List<Map<String, Object>>, true),
        );
        list.add(tile);
      } else {
        var tile = ListTile(
          leading: Padding(
            padding: isSubmenu ? EdgeInsets.only(left: 18.0) : EdgeInsets.zero,
            child: Icon(icon, size: iconSize, color: itemColor(path)),
          ),
          title: Padding(
            padding: isSubmenu ? EdgeInsets.only(left: 18.0) : EdgeInsets.zero,
            child: Text(title, style: TextStyle(fontSize: fontSize, color: itemColor(path))),
          ),
          selected: _selectedItem == path,
          selectedTileColor: Color.fromRGBO(48, 93, 103, 1.0),
          onTap: () => setState(() {
            _selectedItem = path;
          }),
        );
        list.add(tile);
      }
    }
    return list;
  }

  Widget drawerHeader() {
    return DrawerHeader(
      child: Padding(
        padding: EdgeInsets.all(40.0),
        child: Image.asset('assets/images/jos-logo.png'),
      ),
    );
  }
}
