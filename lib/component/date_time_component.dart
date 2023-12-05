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
  String _serverDate = '';
  String _serverTime = '';

  @override
  void initState() {
    super.initState();
    _fetchSystemDateTime();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Row(
            children: [
              OutlinedButton(onPressed: () => _showDatePicker(context), child: Text(_serverDate)),
              SizedBox(width: 8),
              OutlinedButton(onPressed: () => _showTimePicker(context), child: Text(_serverTime)),
            ],
          ),
          Align(alignment: Alignment.bottomRight, child: ElevatedButton(onPressed: () => _updateDateTime(), child: Text('Apply')))
        ],
      ),
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

  void _fetchSystemDateTime() async {
    developer.log('Fetch system date time called');
    var result = await RestClient.rpc(RPC.dateTimeInformation);
    if (result != null) {
      var json = jsonDecode(result);
      setState(() {
        _serverDate = json['result']['zonedDateTime'].split(' ')[0];
        _serverTime = json['result']['zonedDateTime'].split(' ')[1];
      });
    }
  }

  void _updateDateTime() {
    developer.log('Update date time');
    String param = '$_serverDate $_serverTime';
    RestClient.rpc(RPC.systemSetDateTime, parameters: {'dateTime': param});
    displayInfo('System date time updated', context);
  }
}
