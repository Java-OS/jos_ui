import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/text_field_box.dart';
import 'package:jos_ui/controller/oci_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';
import 'package:jos_ui/dialog/container/container_terminal.dart';
import 'package:jos_ui/model/container/container_info.dart';

final _containerController = Get.put(OciController());

Future<void> displayExecInstance(ContainerInfo containerInfo) async {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Create exec instance'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldBox(controller: _containerController.execEditingController, label: 'cmd'),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(onPressed: () {
                  Get.back();
                  displayContainerTerminal(containerInfo);
                }, child: Text('Execute')),
              ),
            ],
          ),
        ],
      );
    },
  );
}
