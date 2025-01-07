import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/oci_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';
import 'package:jos_ui/widget/text_field_box_widget.dart';

final _containerController = Get.put(OciController());

Future<void> displayCreateNetwork() async {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Create network'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldBox(controller: _containerController.networkNameEditingController, label: 'Name'),
              SizedBox(height: 8),
              TextFieldBox(controller: _containerController.networkSubnetEditingController, label: 'Network Range (Ex. 172.16.1.0/24)'),
              SizedBox(height: 8),
              TextFieldBox(controller: _containerController.networkGatewayEditingController, label: 'Gateway (Ex. 172.16.1.1)'),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(onPressed: () => _containerController.createNetwork(), child: Text('Create')),
              ),
            ],
          )
        ],
      );
    },
  ).then((_) => _containerController.clearNetworkParameters());
}
