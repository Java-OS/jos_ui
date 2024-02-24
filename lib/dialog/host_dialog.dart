import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/network_controller.dart';
import 'package:jos_ui/widget/text_field_box_widget.dart';

NetworkController _networkController = Get.put(NetworkController());

Future<void> displayHostModal(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Host'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [TextFieldBox(controller: _networkController.hostIpEditingController, label: 'Ip address'), SizedBox(height: 8), TextFieldBox(controller: _networkController.hostHostnameEditingController, label: 'Hostname'), SizedBox(height: 10), Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: () => _networkController.addHost(), child: Text('Apply')))],
          )
        ],
      );
    },
  ).then((value) => _networkController.fetchHosts());
}
