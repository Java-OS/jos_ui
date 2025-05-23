import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/global/panel_drawer_controller.dart';

class DrawerComponent extends StatelessWidget {
  DrawerComponent({super.key});

  final _panelDrawerController = Get.put(PanelDrawerController());

  @override
  Widget build(BuildContext context) {
    var menuList = buildList(_panelDrawerController.menuItems, false);
    menuList.insert(0, drawerHeader());
    return Drawer(
      child: ListView(
        children: menuList,
      ),
    );
  }

  List<Widget> buildList(List<Map<String, Object>> items, bool isSubmenu) {
    var list = <Widget>[];
    for (var item in items) {
      var title = item['title'] as String;
      var icon = item.containsKey('icon') ? item['icon'] as IconData : null;
      var svg = item.containsKey('svg') ? item['svg'] as SvgPicture : null;
      var fontSize = item['font-size'] as double;
      var iconSize = item['icon-size'] as double;
      var submenu = item['submenu'];
      var path = item['path'] as String;
      var isOnPath = path == Get.currentRoute;
      if (submenu != null) {
        var tile = ExpansionTile(
          leading: svg ?? Icon(icon,color: Colors.black87),
          title: Text(title,style: TextStyle(color: Colors.black87)),
          initiallyExpanded: _panelDrawerController.selectedItem.value.startsWith(path),
          onExpansionChanged: (_) => _panelDrawerController.submenuItem.value = path,
          children: buildList(submenu as List<Map<String, Object>>, true),
        );
        list.add(tile);
      } else {
        var tile = ListTile(
          selectedColor: Colors.black87,
          selectedTileColor: Colors.lightBlueAccent,
          leading: Padding(
            padding: isSubmenu ? EdgeInsets.only(left: 18.0) : EdgeInsets.zero,
            child: svg ?? Icon(icon, size: iconSize,color: isOnPath ? Colors.white : Colors.black87),
          ),
          title: Padding(
            padding: isSubmenu ? EdgeInsets.only(left: 18.0) : EdgeInsets.zero,
            child: Text(title, style: TextStyle(fontSize: fontSize,color: isOnPath ? Colors.white : Colors.black87)),
          ),
          selected: isOnPath,
          onTap: () => _panelDrawerController.routeTo(path),
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
