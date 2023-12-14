import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/authentication_controller.dart';

class TopMenuComponent extends StatefulWidget {
  const TopMenuComponent({super.key});

  @override
  State<TopMenuComponent> createState() => _TopMenuComponentState();
}

class _TopMenuComponentState extends State<TopMenuComponent> {
  AuthenticationController authenticationController = Get.put(AuthenticationController());
  int _hoverIndex = -1;

  final menuItems = [
    ['/dashboard', Colors.blueAccent, Icons.dashboard],
    ['/settings', Colors.blueAccent, Icons.settings],
    ['/network', Colors.blueAccent, Icons.lan_outlined],
    ['/modules', Colors.blueAccent, Icons.view_module],
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
              border: Border.all(
                  color: _hoverIndex == index
                      ? Colors.white
                      : currentRoute == routePath
                          ? Colors.transparent
                          : Colors.white38),
              color: currentRoute.startsWith(routePath) ? menuColor : Colors.transparent,
            ),
            width: 80,
            height: 80,
            duration: Duration(milliseconds: 200),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Icon(menuIcon,
                      size: 32,
                      color: _hoverIndex == index
                          ? routePath == '/logout'
                              ? Colors.red
                              : Colors.white
                          : currentRoute.startsWith(routePath)
                              ? Colors.white
                              : Colors.white38),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void navigate(String routePath) {
    if (routePath == '/settings') {
      Get.offNamed('$routePath/0');
    } else if (routePath == '/logout') {
      authenticationController.logout();
    } else {
      Get.offNamed(routePath);
    }
  }
}
