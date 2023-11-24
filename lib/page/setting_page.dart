import 'package:flutter/material.dart';
import 'package:jos_ui/component/side_menu_component.dart';
import 'package:jos_ui/component/top_menu_component.dart';
import 'package:jos_ui/page_base_content.dart';

class SettingPage extends StatefulWidget {
  final int tabIndex;
  const SettingPage({super.key, required this.tabIndex});

  @override
  State<SettingPage> createState() => _SystemPageState();
}

class _SystemPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return getPageContent(child: _pageContent());
  }

  Widget _pageContent() {
    return Center(
      child: SizedBox(
        width: 600,
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopMenuComponent(selectedIndex: 1),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SideMenuComponent(indexTab : widget.tabIndex),
                Container(
                  width: 510,
                  height: 400,
                  color: Color.fromRGBO(236, 226, 226, 1.0),
                  child: Text('Content'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
