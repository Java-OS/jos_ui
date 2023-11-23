import 'package:flutter/material.dart';

class TopMenuComponent extends StatefulWidget {
  const TopMenuComponent({super.key});

  @override
  State<TopMenuComponent> createState() => _HomePageState();
}

class _HomePageState extends State<TopMenuComponent> {
  int _selectedIndex = 0;
  int _hoverIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: getTopMenuItems(),
          ),
          menuItem(4)
        ],
      ),
    );
  }

  final menuIcons = [
    Icons.info_outline_rounded,
    Icons.settings,
    Icons.groups_sharp,
    Icons.view_module,
    Icons.logout_outlined,
  ];

  List<Widget> getTopMenuItems() => List.generate(4, (index) => menuItem(index));

  Widget menuItem(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: MouseRegion(
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
              _selectedIndex = index;
            });
          },
          child: AnimatedContainer(
            decoration: BoxDecoration(
              border: Border.all(
                  color: _hoverIndex == index
                      ? Colors.white
                      : _selectedIndex == index
                          ? Colors.transparent
                          : Colors.white38),
              color: _selectedIndex == index ? index == 4 ? Colors.redAccent : Colors.blueAccent : Colors.transparent,
            ),
            width: 80,
            height: 80,
            duration: Duration(milliseconds: 200),
            child: Center(
              child: Icon(
                menuIcons[index],
                size: 32,
                color: _hoverIndex == index
                    ? Colors.white
                    : _selectedIndex == index
                        ? Colors.white
                        : Colors.white38,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
