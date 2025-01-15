import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/controller/system_controller.dart';
import 'package:jos_ui/dialog/system_dialog.dart';
import 'package:jos_ui/widget/text_field_box_widget.dart';

class SettingsBasicPage extends StatefulWidget {
  const SettingsBasicPage({super.key});

  @override
  State<SettingsBasicPage> createState() => _SettingsBasicPageState();
}

class _SettingsBasicPageState extends State<SettingsBasicPage> {
  final SystemController _systemController = Get.put(SystemController());

  @override
  void initState() {
    _systemController.fetchHostname();
    _systemController.fetchDnsNameserver();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContent(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
      ),
    );
  }
}
