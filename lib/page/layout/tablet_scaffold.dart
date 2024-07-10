import 'package:flutter/material.dart';
import 'package:jos_ui/component/drawer_component.dart';

class TabletScaffold extends StatefulWidget {
  final Widget content;

  const TabletScaffold({super.key, required this.content});

  @override
  State<TabletScaffold> createState() => _TabletScaffoldState();
}

class _TabletScaffoldState extends State<TabletScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: DrawerComponent(),
      body: Column(
        children: [
          widget.content,
        ],
      ),
    );
  }
}
