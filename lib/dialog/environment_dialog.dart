import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/environment_controller.dart';
import 'package:jos_ui/widget/text_box_widget.dart';

EnvironmentController _environmentController = Get.put(EnvironmentController());

Future<void> addEnvironment(BuildContext context) async {
  _displayModal(context, _environmentController.setSystemEnvironment);
}

Future<void> updateEnvironment(String key, String value, BuildContext context) async {
  _environmentController.keyEditingController.text = key;
  _environmentController.valueEditingController.text = value;
  _displayModal(context, _environmentController.updateEnvironment);
}

Future<void> _displayModal(BuildContext context, Function execute) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Environment'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextBox(controller: _environmentController.keyEditingController, label: 'Key'),
              SizedBox(height: 8),
              TextBox(controller: _environmentController.valueEditingController, label: 'Value'),
              SizedBox(height: 20),
              Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: () => execute(), child: Text('Apply')))
            ],
          )
        ],
      );
    },
  );
}
