import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/tab_content.dart';
import 'package:jos_ui/controller/container_controller.dart';
import 'package:jos_ui/dialog/container_dialog.dart';

class OCITabImages extends StatefulWidget {
  const OCITabImages({super.key});

  @override
  State<OCITabImages> createState() => OCITabImagesState();
}

class OCITabImagesState extends State<OCITabImages> {
  final _containerController = Get.put(ContainerController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabContent(
      title: 'Images',
      toolbar: OutlinedButton(
        onPressed: () => displayContainerSearchImage(),
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
