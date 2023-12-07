import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:jos_ui/modal/message_modal.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/service/rest_api_service.dart';

class DateTimeComponent extends StatefulWidget {
  const DateTimeComponent({super.key});

  @override
  State<DateTimeComponent> createState() => _DateTimeComponentState();
}

class _DateTimeComponentState extends State<DateTimeComponent> {
  bool _isNtpActive = false;
  final TextEditingController _ntpServer = TextEditingController();
  final TextEditingController _ntpInterval = TextEditingController();

  String _serverDate = '';
  String _serverTime = '';

  /* NTP sync parameters */
  String _leapIndicator = '';
  String _version = '';
  String _mode = '';
  String _stratum = '';
  String _poll = '';
  String _precision = '';
  String _rootDelay = '';
  String _rootDispersion = '';
  String _referenceIdentifier = '';
  String _referenceTimestamp = '';
  String _originateTimestamp = '';
  String _receiveTimestamp = '';
  String _transmitTimestamp = '';

  @override
  void initState() {
    super.initState();
    _fetchNtpInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(value: _isNtpActive, onChanged: (e) => switchToNtp(e!)),
                      SizedBox(width: 4),
                      Text('Set date and time automatically', style: TextStyle()),
                    ],
                  ),
                  Row(
                    children: [
                      Visibility(
                        visible: !_isNtpActive,
                        child: Tooltip(
                          message: 'Sync from hardware clock',
                          preferBelow: false,
                          verticalOffset: 22,
                          child: OutlinedButton(onPressed: () => _hcToSys(), child: Icon(Icons.settings_backup_restore, size: 16, color: Colors.black)),
                        ),
                      ),
                      SizedBox(width: 8),
                      Tooltip(
                        message: 'Update hardware clock',
                        preferBelow: false,
                        verticalOffset: 22,
                        child: OutlinedButton(onPressed: () => _sysToHc(), child: Icon(Icons.commit_rounded, size: 16, color: Colors.black)),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 4),
              Visibility(
                visible: _isNtpActive,
                replacement: displayManualDateTimeComponent(),
                child: displayNtpComponent(),
              ),
            ],
          ),
          Align(alignment: Alignment.bottomRight, child: ElevatedButton(onPressed: () => _apply(), child: Text('Apply')))
        ],
      ),
    );
  }

  Widget displayManualDateTimeComponent() {
    return Row(
      children: [
        OutlinedButton(onPressed: () => _showDatePicker(context), child: Text(_serverDate)),
        SizedBox(width: 8),
        OutlinedButton(onPressed: () => _showTimePicker(context), child: Text(_serverTime)),
      ],
    );
  }

  Widget displayNtpComponent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(child: TextField(controller: _ntpServer, decoration: InputDecoration(label: Text('NTP server')))),
            SizedBox(width: 8),
            Flexible(child: TextField(controller: _ntpInterval, decoration: InputDecoration(label: Text('Time interval (milliseconds)')))),
            SizedBox(width: 8),
            Tooltip(
              message: 'Sync from ntp server',
              preferBelow: false,
              verticalOffset: 22,
              child: OutlinedButton(onPressed: () => _syncNTP(), child: Icon(Icons.sync, size: 16, color: Colors.black)),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text('Version: $_version'),
        Text('Mode: $_mode'),
        Text('Reference Identifier: $_referenceIdentifier'),
        Text('Poll: $_poll'),
        Text('Stratum: $_stratum'),
        Text('Leap Indicator: $_leapIndicator'),
        Text('Precision: $_precision'),
        Text('Root Delay: $_rootDelay'),
        Text('Root Dispersion: $_rootDispersion'),
        Text('Reference Timestamp: $_referenceTimestamp'),
        Text('Originate Timestamp: $_originateTimestamp'),
        Text('Receive Timestamp: $_receiveTimestamp'),
        Text('Transmit Timestamp: $_transmitTimestamp'),
      ],
    );
  }

  void _showDatePicker(BuildContext context) {
    var now = DateTime.parse(_serverDate);
    var first = now.copyWith(year: now.year - 8);
    var last = now.copyWith(year: now.year + 9);
    showDatePicker(
      context: context,
      initialDate: DateTime.parse(_serverDate),
      firstDate: first,
      lastDate: last,
    ).then((value) => setState(() => {if (value != null) _serverDate = '${value.year}-${value.month}-${value.day.toString().padLeft(2, '0')}'}));
  }

  void _showTimePicker(BuildContext context) {
    var timeOfDay = TimeOfDay(hour: int.parse(_serverTime.split(':')[0]), minute: int.parse(_serverTime.split(':')[1]));
    showTimePicker(
      context: context,
      initialTime: timeOfDay,
    ).then((value) => setState(() => _serverTime = '${value!.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}:00'));
  }

  void switchToNtp(bool e) {
    setState(() => _isNtpActive = e);
    if (e) {
      _fetchNtpInfo();
    } else {
      _fetchSystemDateTime();
    }
  }

  void _fetchNtpInfo() async {
    developer.log('Fetch NTP Information called');
    var result = await RestClient.rpc(RPC.ntpInformation, context);
    if (result != null) {
      var json = jsonDecode(result);
      bool serverNtpIsActive = json['result']['activate'];
      setState(() {
        _ntpServer.text = json['result']['server'];
        _ntpInterval.text = json['result']['interval'].toString();

        if (!serverNtpIsActive) {
          _fetchSystemDateTime();
        } else {
          _isNtpActive = serverNtpIsActive;
          _syncNTP();
        }
      });
    }
  }

  void _fetchSystemDateTime() async {
    developer.log('Fetch system date time called');
    var result = await RestClient.rpc(RPC.dateTimeInformation, context);
    if (result != null) {
      var json = jsonDecode(result);
      setState(() {
        _serverDate = json['result']['zonedDateTime'].split(' ')[0];
        _serverTime = json['result']['zonedDateTime'].split(' ')[1];
      });
    }
  }

  void _updateDateTime() {
    developer.log('Update date time called');
    String param = '$_serverDate $_serverTime';
    RestClient.rpc(RPC.systemSetDateTime, context, parameters: {'dateTime': param});
    displayInfo('System date & time updated', context);
  }

  Future<void> _activateNtp() async {
    developer.log('Activate NTP called');
    await RestClient.rpc(RPC.ntpActivate, context, parameters: {'activate': _isNtpActive});
    String activeMessage = 'NTP client activated';
    String disabledMessage = 'NTP client disabled';
    if (context.mounted && _isNtpActive) displayInfo(_isNtpActive ? activeMessage : disabledMessage, context);
  }

  Future<void> _setNtpConfiguration() async {
    developer.log('Set NTP configuration called');
    var params = {'server': _ntpServer.text, 'interval': int.parse(_ntpInterval.text)};
    await RestClient.rpc(RPC.ntpServerName, context, parameters: params);
    if (context.mounted) displayInfo('NTP configuration updated', context);
  }

  Future<void> _syncNTP() async {
    developer.log('Sync NTP Called');
    var result = await RestClient.rpc(RPC.ntpSync, context);
    if (result != null) {
      var json = jsonDecode(result);
      setState(() {
        _leapIndicator = json['result']['leapIndicator'].toString();
        _version = json['result']['version'].toString();
        _mode = json['result']['mode'].toString();
        _stratum = json['result']['stratum'].toString();
        _poll = json['result']['poll'].toString();
        _precision = json['result']['precision'].toString();
        _rootDelay = json['result']['rootDelay'].toString();
        _rootDispersion = json['result']['rootDispersion'].toString();
        _referenceIdentifier = json['result']['referenceIdentifier'].toString();
        _referenceTimestamp = json['result']['referenceTimestamp'].toString();
        _originateTimestamp = json['result']['originateTimestamp'].toString();
        _receiveTimestamp = json['result']['receiveTimestamp'].toString();
        _transmitTimestamp = json['result']['transmitTimestamp'].toString();
      });
    }
  }

  Future<void> _hcToSys() async {
    developer.log('Hardware clock to sys called');
    await RestClient.rpc(RPC.dateTimeSyncHctosys, context);
  }

  Future<void> _sysToHc() async {
    developer.log('System to hardware clock called');
    await RestClient.rpc(RPC.dateTimeSyncSystohc, context);
  }

  void _apply() async {
    if (_isNtpActive) {
      _activateNtp().then((value) => _setNtpConfiguration()).then((value) => _syncNTP());
    } else {
      _activateNtp().then((value) => _updateDateTime());
    }
  }
}
