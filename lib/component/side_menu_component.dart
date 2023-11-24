import 'package:flutter/material.dart';
import 'package:jos_ui/constant.dart';

class SideMenuComponent extends StatefulWidget {
  final int indexTab;

  const SideMenuComponent({super.key, required this.indexTab});

  @override
  State<SideMenuComponent> createState() => _HomePageState();
}

class _HomePageState extends State<SideMenuComponent> {
  int _hoverIndex = -1;

  final menuConfigs = [
    [Color.fromRGBO(236, 226, 226, 1.0), Icons.info_outline_rounded],
    [Color.fromRGBO(236, 226, 226, 1.0), Icons.date_range],
    [Color.fromRGBO(236, 226, 226, 1.0), Icons.lan_outlined],
    [Color.fromRGBO(236, 226, 226, 1.0), Icons.join_right],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: getTopMenuItems(),
    );
  }

  List<Widget> getTopMenuItems() => List.generate(4, (index) => menuItem(index));

  Widget menuItem(int index) {
    var menuColor = menuConfigs[index][0] as Color;
    var menuIcon = menuConfigs[index][1] as IconData;
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
            navigatorKey.currentState?.pushReplacementNamed('/setting', arguments: index);
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: AnimatedContainer(
            decoration: BoxDecoration(
              color: widget.indexTab == index ? menuColor : Colors.white10,
            ),
            width: 80,
            height: 50,
            duration: Duration(milliseconds: 200),
            child: Center(
              child: Icon(menuIcon,
                  size: 22,
                  color: _hoverIndex == index
                      ? Colors.blue
                      : widget.indexTab == index
                          ? Colors.blue
                          : Colors.white38),
            ),
          ),
        ),
      ),
    );
  }
}
