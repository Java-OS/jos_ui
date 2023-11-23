import 'package:flutter/material.dart';
import 'package:jos_ui/page_base_content.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _hoverIndex = -1;

  @override
  Widget build(BuildContext context) {
    return getPageContent(child: _pageContent());
  }

  Widget _pageContent() {
    return Center(
      child: SizedBox(
        width: 800,
        height: 600,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: getTopMenuItems(),
          ),
        ),
      ),
    );
  }

  List<Widget> getTopMenuItems() {
    var menuIcons = [
      Icons.info_outline_rounded,
      Icons.settings,
      Icons.groups_sharp,
      Icons.view_module,
    ];

    return List.generate(
      4,
      (index) {
        return Padding(
          padding: const EdgeInsets.only(right: 4.0),
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
                color: _selectedIndex == index ? Colors.blueAccent : Colors.transparent,
              ),
              width: 100,
              height: 100,
              duration: Duration(milliseconds: 200),
              child: Center(
                child: Icon(
                  menuIcons[index],
                  size: 44,
                  color: _hoverIndex == index
                      ? Colors.white
                      : _selectedIndex == index
                          ? Colors.white
                          : Colors.white38,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
