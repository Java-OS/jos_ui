import 'package:flutter/material.dart';
import 'package:jos_ui/constant.dart';

class TopMenuComponent extends StatefulWidget {
  final int selectedIndex;

  const TopMenuComponent({super.key, required this.selectedIndex});

  @override
  State<TopMenuComponent> createState() => _HomePageState();
}

class _HomePageState extends State<TopMenuComponent> {
  int _hoverIndex = -1;

  final menuConfigs = [
    ['/home', Colors.blueAccent, Icons.dashboard],
    ['/setting', Colors.blueAccent, Icons.settings],
    ['/user', Colors.blueAccent, Icons.groups_sharp],
    ['/module', Colors.blueAccent, Icons.view_module],
    ['/', Colors.redAccent, Icons.logout_outlined],
  ];

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
        menuItem(4)
      ],
    );
  }

  List<Widget> getTopMenuItems() => List.generate(4, (index) => menuItem(index));

  Widget menuItem(int index) {
    var routePath = menuConfigs[index][0] as String;
    var menuColor = menuConfigs[index][1] as Color;
    var menuIcon = menuConfigs[index][2] as IconData;
    return MouseRegion(
      onExit: (_) {
        setState(() {
          _hoverIndex = -1;
        });
      },
      child: InkWell(
        onHover: (_) {
          setState(() {
            _hoverIndex = index;
          });
        },
        onTap: () {
          setState(() {
            if (routePath == '/setting') {
              navigatorKey.currentState?.pushReplacementNamed(routePath,arguments: 0);
            } else {
              navigatorKey.currentState?.pushReplacementNamed(routePath);
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.only(right: routePath == '/' ? 0 : 8),
          child: AnimatedContainer(
            decoration: BoxDecoration(
              border: Border.all(
                  color: _hoverIndex == index
                      ? Colors.white
                      : widget.selectedIndex == index
                          ? Colors.transparent
                          : Colors.white38),
              color: widget.selectedIndex == index ? menuColor : Colors.transparent,
            ),
            width: 80,
            height: 80,
            duration: Duration(milliseconds: 200),
            child: Center(
              child: Icon(menuIcon,
                  size: 32,
                  color: _hoverIndex == index
                      ? Colors.white
                      : widget.selectedIndex == index
                          ? Colors.white
                          : Colors.white38),
            ),
          ),
        ),
      ),
    );
  }
}
