import 'package:flutter/material.dart';
import 'package:jos_ui/component/tab_content.dart';
import 'package:jos_ui/dialog/network_routes_dialog.dart';

class OCITabPods extends StatefulWidget {
  const OCITabPods({super.key});

  @override
  State<OCITabPods> createState() => OCITabPodsState();
}

class OCITabPodsState extends State<OCITabPods> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabContent(
      title: 'Pods',
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
