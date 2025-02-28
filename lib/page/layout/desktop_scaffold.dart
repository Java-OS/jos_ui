import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/drawer.dart';
import 'package:jos_ui/controller/authentication_controller.dart';

class DesktopScaffold extends StatefulWidget {
  final Widget content;

  const DesktopScaffold({super.key, required this.content});

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  final _authController = Get.put(AuthenticationController());

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
                  actions: [
                    ElevatedButton.icon(onPressed: () => _authController.logout(), icon: Icon(Icons.logout, size: 16), label: Text('Logout')),
                  ],
                  automaticallyImplyLeading: false,
                  actionsPadding: EdgeInsets.all(14),
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
