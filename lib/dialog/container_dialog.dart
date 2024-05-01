import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/tile_component.dart';
import 'package:jos_ui/controller/container_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';

final _userController = Get.put(ContainerController());

Future<void> displayContainerSearchImage() async {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Search Image'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.only(left: 8,right: 8,bottom: 8),
        titlePadding: EdgeInsets.zero,
        children: [
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              suffix: ElevatedButton(onPressed: () {}, child: Text('Search')),
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            width: 400,
            height: 200,
            child: ListView(
              children: const [
                TileComponent(index: 1, title: Text('Hello'))
              ],
            ),
          )
        ],
      );
    },
  );
}
