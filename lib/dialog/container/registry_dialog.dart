import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/text_field_box_widget.dart';
import 'package:jos_ui/controller/oci_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';

final _containerController = Get.put(OciController());

Future<void> displayAddRegistryDialog() async {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Add new registry'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldBox(controller: _containerController.registryEditingController, label: 'Registry address (Ex. docker.io)'),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(onPressed: () => addItemAndSave(), child: Text('Add')),
              ),
            ],
          )
        ],
      );
    },
  );
}


void addItemAndSave() {
  if (_containerController.registryEditingController.text.trim().isNotEmpty) {
    _containerController.registries.add(_containerController.registryEditingController.text);
  }
  _containerController.saveRegistries();
}