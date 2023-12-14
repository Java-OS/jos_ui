import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/modal/toast.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/service/RpcProvider.dart';

final TextEditingController keyController = TextEditingController();
final TextEditingController valueController = TextEditingController();

Future<void> _setSystemEnvironment(BuildContext context) async {
  developer.log('Add System Environments called');
  var key = keyController.text;
  var value = valueController.text;

  await RestClient.rpc(RPC.systemEnvironmentSet, parameters: {'key': key, 'value': value});
  if (context.mounted) displayInfo('New environment added');
  Get.back();
}

Future<void> displayAddUpdateEnvironmentModal(BuildContext context) async {
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
              TextField(controller: keyController, decoration: InputDecoration(label: Text('Key'), hintStyle: TextStyle(fontSize: 12))),
              TextField(controller: valueController, decoration: InputDecoration(label: Text('Value'), hintStyle: TextStyle(fontSize: 12))),
              SizedBox(height: 20),
              Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: () => _setSystemEnvironment(context), child: Text('Apply')))
            ],
          )
        ],
      );
    },
  );
}
