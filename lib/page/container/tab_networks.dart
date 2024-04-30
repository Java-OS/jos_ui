import 'package:flutter/material.dart';
import 'package:jos_ui/component/tab_content.dart';
import 'package:jos_ui/dialog/network_routes_dialog.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OCITabNetworks extends StatefulWidget {
  const OCITabNetworks({super.key});

  @override
  State<OCITabNetworks> createState() => _OCITabNetworksState();
}

class _OCITabNetworksState extends State<OCITabNetworks> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabContent(
      title: 'Networks',
      toolbar: OutlinedButton(
        onPressed: () => displayNetworkRoutesModal(context),
        child: Icon(Icons.add, size: 16, color: Colors.black),
      ),
      content: ListView(
        children: const [
          ListTile(title: Text('Hello')),
          ListTile(title: Text('Hello')),
          ListTile(title: Text('Hello')),
          ListTile(title: Text('Hello')),
          ListTile(title: Text('Hello')),
          ListTile(title: Text('Hello')),
          ListTile(title: Text('Hello')),
          ListTile(title: Text('Hello')),
          ListTile(title: Text('Hello')),
          ListTile(title: Text('Hello')),
          ListTile(title: Text('Hello')),
          ListTile(title: Text('Hello')),
          ListTile(title: Text('Hello')),
          ListTile(title: Text('Hello')),
          ListTile(title: Text('Hello')),
          ListTile(title: Text('Hello')),
          ListTile(title: Text('Hello')),
          ListTile(title: Text('Hello')),
          ListTile(title: Text('Hello')),
          ListTile(title: Text('Hello')),
          ListTile(title: Text('Hello')),
          ListTile(title: Text('Hello')),
          ListTile(title: Text('Hello')),
          ListTile(title: Text('Hello')),
          ListTile(title: Text('Hello')),
          ListTile(title: Text('Hello')),
        ],
      ),
    );
  }
}
