import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/network_controller.dart';
import 'package:jos_ui/model/network/ethernet.dart';
import 'package:jos_ui/widget/drop_down_widget.dart';
import 'package:jos_ui/widget/tab_widget.dart';
import 'package:jos_ui/widget/text_box_widget.dart';

NetworkController _networkController = Get.put(NetworkController());

Future<void> displayEthernetConfig(String ethName, BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Ethernet'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextBox(controller: _networkController.addressEditingController, label: 'Ip Address'),
              SizedBox(height: 8),
              TextBox(controller: _networkController.netmaskEditingController, label: 'Netmask'),
              SizedBox(height: 8),
              Align(alignment: Alignment.bottomRight, child: ElevatedButton(onPressed: () => _networkController.setIp(ethName), child: Text('Apply')))
            ],
          )
        ],
      );
    },
  );
}