import 'package:flutter/material.dart';
import 'package:jos_ui/component/tab_content.dart';
import 'package:jos_ui/dialog/network_routes_dialog.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OCITabSettings extends StatefulWidget {
  const OCITabSettings({super.key});

  @override
  State<OCITabSettings> createState() => OCITabSettingsState();
}

class OCITabSettingsState extends State<OCITabSettings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabContent(
      title: 'Settings',
      toolbar: OutlinedButton(
        onPressed: () => displayNetworkRoutesModal(context),
        child: Icon(Icons.add, size: 16, color: Colors.black),
      ),
      content: Text('Hello'),
    );
  }
}
