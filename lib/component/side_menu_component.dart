import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';

class SideMenuComponent extends StatefulWidget {
  final List<IconData> menuItems;
  final String baseMenuPath;
  const SideMenuComponent({super.key, required this.menuItems, required this.baseMenuPath});

  @override
  State<SideMenuComponent> createState() => _SideMenuComponentState();
}

class _SideMenuComponentState extends State<SideMenuComponent> {
  int _hoverIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: getSideMenuItems(),
    );
  }

  List<Widget> getSideMenuItems() => List.generate(widget.menuItems.length, (index) => menuItem(index));

  Widget menuItem(int index) {
    var currentParameter = int.parse(Get.parameters['index'] ?? '0');
    var mi = widget.menuItems[index];
    return MouseRegion(
      onExit: (_) => setState(() => _hoverIndex = -1),
      child: InkWell(
        onHover: (_) => setState(() => _hoverIndex = index),
        onTap: () => Get.offAllNamed('/${widget.baseMenuPath}/$index'),
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
