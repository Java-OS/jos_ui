import 'package:flutter/material.dart';
import 'package:jos_ui/constant.dart';

class TabBox extends StatefulWidget {
  final List<TabItem> tabs;
  final List<Widget> contents;
  final double? width;

  const TabBox({super.key, required this.tabs, required this.contents, this.width});

  @override
  State<TabBox> createState() => _TabBoxState();
}

class _TabBoxState extends State<TabBox> {
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      color: componentBackgroundColor,
      child: createContent(),
    );
  }

  Row createTabs() {
    List<Widget> items = [];
    for (var i = 0; i < widget.tabs.length; i++) {
      var tabItem = widget.tabs[i];
      var p = Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: InkWell(
          mouseCursor: SystemMouseCursors.click,
          onTap: () => setState(() => selectedTabIndex = i),
          child: Container(
            constraints: BoxConstraints(minWidth: 70),
            color: selectedTabIndex == i ? Colors.white : Colors.grey.shade300,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
              child: Row(
                children: [
                  Icon(
                    tabItem.icon,
                    color: selectedTabIndex == i ? tabItem.color : Colors.grey,
                    size: tabItem.iconSize,
                  ),
                  SizedBox(width: 4),
                  Text(
                    tabItem.text,
                    style: TextStyle(
                      fontSize: tabItem.fontSize,
                      fontWeight: tabItem.fontWeight,
                      color: selectedTabIndex == i ? tabItem.color : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      items.add(p);
    }
    return Row(children: items);
  }

  Widget createContent() {
    List<Widget> items = [];
    items.add(createTabs());
    for (var i = 0; i < widget.contents.length; i++) {
      var c = Visibility(
        visible: selectedTabIndex == i,
        child: Expanded(child: Container(color: Colors.white, child: widget.contents[i])),
      );
      items.add(c);
    }
    return Column(children: items);
  }
}

class TabItem {
  final String text;
  final IconData icon;
  final double? iconSize;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;

  const TabItem({required this.text, required this.icon, this.iconSize, this.color, this.fontWeight, this.fontSize});
}
