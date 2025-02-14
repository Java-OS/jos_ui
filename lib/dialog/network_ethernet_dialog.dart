import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/text_field_box.dart';
import 'package:jos_ui/controller/network_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';
import 'package:jos_ui/model/network/ethernet.dart';

NetworkController _networkController = Get.put(NetworkController());

Future<void> displayEthernetConfig(Ethernet eth, BuildContext context) async {
  _networkController.addressEditingController.text = eth.ip ?? '';
  _networkController.netmaskEditingController.text = eth.netmask ?? '';
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
              TextFieldBox(controller: _networkController.addressEditingController, label: 'Ip Address'),
              SizedBox(height: 8),
              TextFieldBox(controller: _networkController.netmaskEditingController, label: 'Netmask', isEnable: !_networkController.addressEditingController.text.contains('/')),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(onPressed: () => _networkController.setIp(eth.iface), child: Text('Apply')),
              ),
            ],
          )
        ],
      );
    },
  );
}
