import 'package:flutter/material.dart';
import 'package:jos_ui/component/drawer.dart';

class MobileScaffold extends StatefulWidget {
  final Widget content;

  const MobileScaffold({super.key, required this.content});

  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
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
