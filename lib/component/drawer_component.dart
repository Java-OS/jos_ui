import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/panel_drawer_controller.dart';

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
      var icon = item['icon'] as IconData;
      var fontSize = item['font-size'] as double;
      var iconSize = item['icon-size'] as double;
      var submenu = item['submenu'];
      var path = item['path'] as String;
      if (submenu != null) {
        var tile = ExpansionTile(
          leading: Icon(icon),
          title: Text(title),
          initiallyExpanded: _panelDrawerController.selectedItem.value.startsWith(path),
          onExpansionChanged: (_) => _panelDrawerController.submenuItem.value = path,
          children: buildList(submenu as List<Map<String, Object>>, true),
        );
        list.add(tile);
      } else {
        var tile = ListTile(
          leading: Padding(
            padding: isSubmenu ? EdgeInsets.only(left: 18.0) : EdgeInsets.zero,
            child: Icon(icon, size: iconSize),
          ),
          title: Padding(
            padding: isSubmenu ? EdgeInsets.only(left: 18.0) : EdgeInsets.zero,
            child: Text(title, style: TextStyle(fontSize: fontSize)),
          ),
          selected: _panelDrawerController.selectedItem.value == path,
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
