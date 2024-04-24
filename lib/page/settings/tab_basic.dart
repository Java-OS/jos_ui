import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/system_controller.dart';
import 'package:jos_ui/dialog/system_dialog.dart';
import 'package:jos_ui/widget/text_field_box_widget.dart';

class TabBasic extends StatefulWidget {
  const TabBasic({super.key});

  @override
  State<TabBasic> createState() => TabBasicPageState();
}

class TabBasicPageState extends State<TabBasic> {
  final SystemController _systemController = Get.put(SystemController());

  @override
  void initState() {
    _systemController.fetchHostname();
    _systemController.fetchDnsNameserver();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Backup', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
        Divider(),
        TextFieldBox(
          isEnable: false,
          isPassword: false,
          label: 'Hostname',
          controller: _systemController.hostnameEditingController,
          onClick: () => displayHostnameModal(context),
        ),
        SizedBox(height: 16),
        TextFieldBox(
          isEnable: false,
          isPassword: false,
          label: 'DNS Nameserver (Max 3 ip, Comma delimited)',
          controller: _systemController.dnsEditingController,
          onClick: () => displayDNSNameserverModal(context),
        ),
      ],
    );
  }
}
