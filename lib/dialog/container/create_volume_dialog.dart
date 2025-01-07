import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/oci_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';
import 'package:jos_ui/widget/text_field_box_widget.dart';

final _containerController = Get.put(OciController());

Future<void> displayCreateVolume() async {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Create volume'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldBox(controller: _containerController.volumeNameEditingController, label: 'Name'),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(onPressed: () => _containerController.createVolume(), child: Text('Create')),
              ),
            ],
          )
        ],
      );
    },
  );
}
