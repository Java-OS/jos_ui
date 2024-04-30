import 'package:flutter/material.dart';
import 'package:jos_ui/component/tab_content.dart';
import 'package:jos_ui/dialog/network_routes_dialog.dart';

class OCITabContainers extends StatefulWidget {
  const OCITabContainers({super.key});

  @override
  State<OCITabContainers> createState() => OCITabContainersState();
}

class OCITabContainersState extends State<OCITabContainers> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabContent(
      title: 'Containers',
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
