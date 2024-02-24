import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/system_controller.dart';
import 'package:jos_ui/dialog/system_dialog.dart';
import 'package:jos_ui/widget/text_field_box_widget.dart';

class BasicComponent extends StatefulWidget {
  const BasicComponent({super.key});

  @override
  State<BasicComponent> createState() => _BasicComponentState();
}

class _BasicComponentState extends State<BasicComponent> {
  final SystemController systemController = Get.put(SystemController());

  @override
  void initState() {
    super.initState();
    systemController.fetchHostname();
    systemController.fetchDnsNameserver();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFieldBox(
              isEnable: false,
              isPassword: false,
              label: 'Hostname',
              controller: systemController.hostnameEditingController,
              onClick: () => displayHostnameModal(context),
            ),
            SizedBox(height: 16),
            TextFieldBox(
              isEnable: false,
              isPassword: false,
              label: 'DNS Nameserver (Max 3 ip, Comma delimited)',
              controller: systemController.dnsEditingController,
              onClick: () => displayDNSNameserverModal(context),
            ),
          ],
        ),
      ),
    );
  }
}
