import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/network_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';
import 'package:jos_ui/widget/text_field_box_widget.dart';

NetworkController _networkController = Get.put(NetworkController());

Future<void> displayNetworkModal(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Network'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldBox(controller: _networkController.networkNetworkEditingController, label: 'Network'),
              SizedBox(height: 8),
              TextFieldBox(controller: _networkController.networkNameEditingController, label: 'name'),
              SizedBox(height: 10),
              Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: () => _networkController.addNetwork(), child: Text('Apply'))),
            ],
          )
        ],
      );
    },
  ).then((value) => _networkController.fetchHosts());
}
