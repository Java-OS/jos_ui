import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/authentication_controller.dart';
import 'package:jos_ui/controller/jvm_controller.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TopMenuComponent extends StatefulWidget {
  const TopMenuComponent({super.key});

  @override
  State<TopMenuComponent> createState() => _TopMenuComponentState();
}

class _TopMenuComponentState extends State<TopMenuComponent> with SingleTickerProviderStateMixin {
  final _authenticationController = Get.put(AuthenticationController());
  final _jvmController = Get.put(JvmController());
  late final AnimationController _animationController = AnimationController(duration: Duration(seconds: 2), vsync: this)..repeat();

  int _hoverIndex = -1;

  final menuItems = [
    ['/dashboard', Colors.blueAccent, Icons.dashboard],
    ['/settings', Colors.blueAccent, Icons.settings],
    ['/networks', Colors.blueAccent, Icons.lan_outlined],
    ['/modules', Colors.blueAccent, Icons.view_module],
    ['/containers', Colors.blueAccent, MdiIcons.oci],
    ['/logout', Colors.redAccent, Icons.logout_outlined],
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: getTopMenuItems(),
        ),
        menuItem(menuItems.length - 1)
      ],
    );
  }

  List<Widget> getTopMenuItems() => List.generate(menuItems.length - 1, (index) => menuItem(index));

  Widget menuItem(int index) {
    var currentRoute = Get.routing.current;
    var routePath = menuItems[index][0] as String;
    var menuColor = menuItems[index][1] as Color;
    var menuIcon = menuItems[index][2] as IconData;
    return MouseRegion(
      onExit: (_) => setState(() => _hoverIndex = -1),
      child: InkWell(
        onHover: (_) => setState(() => _hoverIndex = index),
        onTap: () => navigate(routePath),
        child: Padding(
          padding: EdgeInsets.only(right: routePath == '/' ? 0 : 8),
          child: AnimatedContainer(
            decoration: BoxDecoration(
              border: Border.all(color: getBorderColor(index, routePath, currentRoute)),
              color: currentRoute.startsWith(routePath) ? menuColor : Colors.transparent,
            ),
            width: 80,
            height: 80,
            duration: Duration(milliseconds: 500),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Obx(
                    () => Visibility(
                      visible: _jvmController.jvmNeedRestart.isTrue && routePath == '/dashboard',
                      replacement: Icon(menuIcon, size: 32, color: getIconColor(index, routePath, currentRoute)),
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (_, child) => Transform.rotate(angle: _animationController.value * 2 * math.pi, child: child),
                        child: Icon(Icons.autorenew_rounded, size: 32, color: getIconColor(index, routePath, currentRoute)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color getIconColor(int index, String routePath, String currentRoute) {
    if (_hoverIndex == index && routePath == '/logout') {
      return Colors.red;
    } else if (_hoverIndex == index || currentRoute.startsWith(routePath)) {
      return Colors.white;
    } else {
      return Colors.white38;
    }
  }

  Color getBorderColor(int index, String routePath, String currentRoute) {
    if (_hoverIndex == index && routePath == '/logout') {
      return Colors.red;
    } else if (_hoverIndex == index) {
      return Colors.white;
    } else if (currentRoute == routePath) {
      return Colors.transparent;
    } else {
      return Colors.white38;
    }
  }

  void navigate(String routePath) {
    if (routePath == '/settings' || routePath == '/networks') {
      Get.toNamed('$routePath/0');
    } else if (routePath == '/logout') {
      _authenticationController.logout();
    } else {
      Get.toNamed(routePath);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
