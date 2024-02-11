import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/system_controller.dart';
import 'package:jos_ui/widget/text_field_box_widget.dart';

SystemController _systemController = Get.put(SystemController());

Future<void> displayHostnameModal(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Change hostname'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldBox(controller: _systemController.hostnameEditingController, label: 'Hostname'),
              SizedBox(height: 10),
              Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: () => _systemController.changeHostname(), child: Text('Apply')))
            ],
          )
        ],
      );
    },
  ).then((value) => _systemController.fetchHostname());
}

Future<void> displayDNSNameserverModal(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('DNS Nameserver'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldBox(controller: _systemController.dnsEditingController, label: 'DNS'),
              SizedBox(height: 10),
              Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: () => _systemController.setDnsNameserver(), child: Text('Apply')))
            ],
          )
        ],
      );
    },
  ).then((value) => _systemController.fetchDnsNameserver());
}

Future<void> displayHostsModal(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Change hostname'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldBox(controller: _systemController.hostHostnameEditingController, label: 'Hostname'),
              SizedBox(height: 8),
              TextFieldBox(controller: _systemController.hostIpEditingController, label: 'Hostname'),
              SizedBox(height: 8),
              TextFieldBox(controller: _systemController.hostAliasesEditingController, label: 'Hostname'),
              SizedBox(height: 10),
              Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: () => _systemController.changeHostname(), child: Text('Apply')))
            ],
          )
        ],
      );
    },
  ).then((value) => _systemController.fetchHosts());
}
