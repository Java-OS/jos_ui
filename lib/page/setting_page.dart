import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:jos_ui/component/date_time_component.dart';
import 'package:jos_ui/component/environment_component.dart';
import 'package:jos_ui/component/network_component.dart';
import 'package:jos_ui/component/ntp_component.dart';
import 'package:jos_ui/component/side_menu_component.dart';
import 'package:jos_ui/component/top_menu_component.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/modal/alert_modal.dart';
import 'package:jos_ui/modal/message_modal.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/page_base_content.dart';
import 'package:jos_ui/service/rest_api_service.dart';
import 'package:jos_ui/service/storage_service.dart';

class SettingPage extends StatefulWidget {
  final int tabIndex;

  const SettingPage({super.key, required this.tabIndex});

  @override
  State<SettingPage> createState() => _SystemPageState();
}

class _SystemPageState extends State<SettingPage> {
  final TextEditingController _hostnameController = TextEditingController();

  bool _useNtp = false;
  String _hostname = '';

  @override
  Widget build(BuildContext context) {
    return getPageContent(child: _pageContent());
  }

  @override
  void initState() {
    super.initState();
    _fetchHostname();
  }

  Widget _pageContent() {
    return Center(
      child: SizedBox(
        width: 600,
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopMenuComponent(selectedIndex: 1),
            SizedBox(height: 8),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SideMenuComponent(indexTab: widget.tabIndex),
                  chooseTargetTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chooseTargetTab() {
    switch (widget.tabIndex) {
      case 0:
        return displayBasicContent();
      case 1:
        return displayDateAndTimeContent();
      case 2:
        return displayNetworkContent();
      case 3:
        return displayEnvironmentsContent();
      default:
        return displayBasicContent();
    }
  }

  Widget displayBasicContent() {
    return basicContent(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Basic Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
              Divider(),
              Text('Hostname', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _hostnameController,
                decoration: InputDecoration(
                  hintText: 'Enter hostname',
                  hintStyle: TextStyle(fontSize: 12),
                ),
                onSubmitted: (_) => _changeHostname(),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [ElevatedButton(onPressed: () => _changeHostname(), child: Text('Apply'))],
          )
        ],
      ),
    );
  }

  Widget displayDateAndTimeContent() {
    return basicContent(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date and Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
              Divider(),
              Row(
                children: [
                  Checkbox(
                      value: _useNtp,
                      onChanged: (e) {
                        setState(() {
                          _useNtp = e!;
                        });
                      }),
                  SizedBox(width: 4),
                  Text('Set date and time automatically', style: TextStyle()),
                ],
              ),
              SizedBox(height: 30),
              Visibility(visible: _useNtp, replacement: DateTimeComponent(), child: NTPComponent())
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [ElevatedButton(onPressed: () {}, child: Text('Apply'))],
          )
        ],
      ),
    );
  }

  Widget displayNetworkContent() {
    return basicContent(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Network', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
              Divider(),
              NetworkComponent(),
              SizedBox(height: 30),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [ElevatedButton(onPressed: () {}, child: Text('Apply'))],
          )
        ],
      ),
    );
  }

  Widget displayEnvironmentsContent() {
    return basicContent(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Environment Variables', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
          Divider(),
          EnvironmentComponent(),
        ],
      ),
    );
  }

  Widget basicContent({child}) {
    return Expanded(
      child: Container(
        color: componentBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }

  void _fetchHostname() async {
    developer.log('Fetch hostname called');
    var response = await RestClient.rpc(RPC.systemGetHostname);
    if (response != null) {
      var json = jsonDecode(response);
      setState(() {
        _hostname = json['result'];
        _hostnameController.text = _hostname;
      });
    } else {
      if (context.mounted) displayError('Failed to fetch hostname', context);
    }
  }

  void _changeHostname() async {
    developer.log('Change hostname called');
    bool accepted = await displayAlertModal('Warning', 'JVM immediately must be reset after change hostname.', context);
    if (accepted && context.mounted) {
      RestClient.rpc(RPC.systemSetHostname, parameters: {'hostname': _hostnameController.text});
      displaySuccess('Hostname changed', context);

      developer.log('JVM restart called');
      RestClient.rpc(RPC.jvmRestart);
      displaySuccess('JVM Restarted', context);

      developer.log('Force Logout');
      StorageService.removeItem('token');
      navigatorKey.currentState?.pushReplacementNamed('/');
    }
  }
}
