import 'package:flutter/material.dart';
import 'package:jos_ui/component/top_menu_component.dart';
import 'package:jos_ui/page_base_content.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

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
          children: const [TopMenuComponent(selectedIndex: 1), SizedBox(height: 8), Text('Setting Page', style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold,color: Colors.white))],
        ),
      ),
    );
  }
}
