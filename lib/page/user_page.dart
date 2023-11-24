import 'package:flutter/material.dart';
import 'package:jos_ui/component/top_menu_component.dart';
import 'package:jos_ui/page_base_content.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
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
          children: const [TopMenuComponent(selectedIndex: 2), SizedBox(height: 8), Text('User Page', style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold,color: Colors.white))],
        ),
      ),
    );
  }
}
