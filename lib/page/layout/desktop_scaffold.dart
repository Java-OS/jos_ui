import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/drawer.dart';
import 'package:jos_ui/controller/authentication_controller.dart';
import 'package:jos_ui/dialog/power_dialog.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DesktopScaffold extends StatefulWidget {
  final Widget content;

  const DesktopScaffold({super.key, required this.content});

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  final _authController = Get.put(AuthenticationController());

  bool _hoverOnLogout = false;
  bool _hoverOnPower = false;

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
                PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: AppBar(
                    actions: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onHover:(e) => setState(() => _hoverOnPower = true),
                        onExit:(e) => setState(() => _hoverOnPower = false),
                        child: GestureDetector(
                          onTap: () => displayPowerModal(),
                          child: AnimatedContainer(
                            curve: Curves.easeInOut,
                            color: _hoverOnPower ? Colors.blue : Colors.transparent,
                            width: 60,
                            duration: Duration(milliseconds: 600),
                            child: Icon(Icons.power_settings_new_outlined,color: _hoverOnPower ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onHover:(e) => setState(() => _hoverOnLogout = true),
                        onExit:(e) => setState(() => _hoverOnLogout = false),
                        child: AnimatedContainer(
                          curve: Curves.easeInOut,
                          color: _hoverOnLogout ? Colors.blue : Colors.transparent,
                          width: 60,
                          duration: Duration(milliseconds: 600),
                          child: Icon(Icons.logout,color: _hoverOnLogout ? Colors.white : Colors.black),
                        ),
                      ),
                    ],
                    automaticallyImplyLeading: false,
                  ),
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
