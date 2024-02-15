import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/basic_component.dart';
import 'package:jos_ui/component/date_time_component.dart';
import 'package:jos_ui/component/environment_component.dart';
import 'package:jos_ui/component/filesystem_component.dart';
import 'package:jos_ui/component/user_management_component.dart';
import 'package:jos_ui/constant.dart';

class SideMenuComponent extends StatefulWidget {
  const SideMenuComponent({super.key});

  @override
  State<SideMenuComponent> createState() => _SideMenuComponentState();
}

class _SideMenuComponentState extends State<SideMenuComponent> {
  int _hoverIndex = -1;

  final menuItems = [
    Icons.info_outline_rounded,
    Icons.date_range,
    Icons.join_right,
    Icons.groups_sharp,
    Icons.save,
    Icons.copy_sharp,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: getSideMenuItems(),
    );
  }

  List<Widget> getSideMenuItems() => List.generate(menuItems.length, (index) => menuItem(index));

  Widget menuItem(int index) {
    var currentParameter = int.parse(Get.parameters['index'] ?? '0');
    var mi = menuItems[index];
    return MouseRegion(
      onExit: (_) => setState(() => _hoverIndex = -1),
      child: InkWell(
        onHover: (_) => setState(() => _hoverIndex = index),
        onTap: () => Get.offAllNamed('/settings/$index'),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: AnimatedContainer(
            decoration: BoxDecoration(
              color: currentParameter == index ? componentBackgroundColor : Colors.white10,
            ),
            width: 80,
            height: 50,
            duration: Duration(milliseconds: 200),
            child: Center(
              child: Icon(mi,
                  size: 22,
                  color: _hoverIndex == index
                      ? Colors.blue
                      : currentParameter == index
                          ? Colors.blue
                          : Colors.white38),
            ),
          ),
        ),
      ),
    );
  }
}
