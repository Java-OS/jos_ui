import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:jos_ui/modal/alert_modal.dart';
import 'package:jos_ui/modal/toast.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/service/RpcProvider.dart';

class BasicComponent extends StatefulWidget {
  const BasicComponent({super.key});

  @override
  State<BasicComponent> createState() => _BasicComponentState();
}

class _BasicComponentState extends State<BasicComponent> {
  final TextEditingController _hostnameController = TextEditingController();

  String _hostname = '';

  @override
  void initState() {
    super.initState();
    _fetchHostname();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          TextField(
            controller: _hostnameController,
            decoration: InputDecoration(
              label: Text('Hostname'),
            ),
            onSubmitted: (_) => _changeHostname(),
          ),
          Align(alignment: Alignment.bottomRight, child: ElevatedButton(onPressed: () => _changeHostname(), child: Text('Apply')))
        ],
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
      if (context.mounted) displayError('Failed to fetch hostname');
    }
  }

  Future<void> _changeHostname() async {
    developer.log('Change hostname called');
    bool accepted = await displayAlertModal('Warning', 'JVM immediately must be reset after change hostname.');
    if (accepted && context.mounted) {
      RestClient.rpc(RPC.systemSetHostname, parameters: {'hostname': _hostnameController.text}).then((value) => displaySuccess('Hostname changed'));
    }
  }
}
