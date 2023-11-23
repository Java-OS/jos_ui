import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:jos_ui/component/top_menu_component.dart';
import 'package:jos_ui/page_base_content.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return getPageContent(child: _pageContent());
  }

  Widget _pageContent() {
    return Center(
      child: SizedBox(
        width: 800,
        height: 600,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            TopMenuComponent(),
            SizedBox(height: 8),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero
                  ),
                  color: Colors.white24,
                  child: Text('Content',style: TextStyle(color: Colors.white,fontSize: 44)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
