import 'package:flutter/material.dart';
import 'package:jos_ui/component/drawer.dart';

class DesktopScaffold extends StatefulWidget {
  final Widget content;

  const DesktopScaffold({super.key, required this.content});

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerComponent(),
          Expanded(
            child: Column(
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                ),
                Expanded(child: widget.content),
              ],
            ),
          )
        ],
      ),
    );
  }
}
