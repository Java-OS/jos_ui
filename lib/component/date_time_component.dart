import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/date_time_controller.dart';
import 'package:jos_ui/dialog/toast.dart';
import 'package:jos_ui/widget/text_box_widget.dart';

class DateTimeComponent extends StatefulWidget {
  const DateTimeComponent({super.key});

  @override
  State<DateTimeComponent> createState() => _DateTimeComponentState();
}

class _DateTimeComponentState extends State<DateTimeComponent> {
  final DateTimeController dateTimeController = Get.put(DateTimeController());

  @override
  void initState() {
    super.initState();
    dateTimeController.fetchNtpInfo();
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
                      Obx(() => Checkbox(value: dateTimeController.isNtpActive.value, onChanged: (e) => switchToNtp(e!))),
                      SizedBox(width: 4),
                      Text('Set date and time automatically', style: TextStyle()),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(
                        () => Visibility(
                          visible: !dateTimeController.isNtpActive.value,
                          child: Tooltip(
                            message: 'Sync from hardware clock',
                            preferBelow: false,
                            verticalOffset: 22,
                            child: OutlinedButton(onPressed: () => dateTimeController.hcToSys(), child: Icon(Icons.settings_backup_restore, size: 16, color: Colors.black)),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Tooltip(
                        message: 'Update hardware clock',
                        preferBelow: false,
                        verticalOffset: 22,
                        child: OutlinedButton(onPressed: () => dateTimeController.sysToHc(), child: Icon(Icons.commit_rounded, size: 16, color: Colors.black)),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 4),
              Obx(
                () => Visibility(
                  visible: dateTimeController.isNtpActive.value,
                  replacement: displayManualDateTimeComponent(),
                  child: displayNtpComponent(),
                ),
              ),
            ],
          ),
          Align(alignment: Alignment.bottomRight, child: ElevatedButton(onPressed: () => dateTimeController.apply(), child: Text('Apply')))
        ],
      ),
    );
  }

  Widget displayManualDateTimeComponent() {
    return Obx(
      () => Row(
        children: [
          OutlinedButton(onPressed: () => _showDatePicker(context), child: Text(dateTimeController.serverDate.value)),
          SizedBox(width: 8),
          OutlinedButton(onPressed: () => _showTimePicker(context), child: Text(dateTimeController.serverTime.value)),
        ],
      ),
    );
  }

  Widget displayNtpComponent() {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(child: TextBox(controller: dateTimeController.ntpServerEditingController, label: 'NTP server')),
              SizedBox(width: 8),
              Flexible(child: TextBox(controller: dateTimeController.ntpIntervalEditingController, label: 'Time interval (milliseconds)')),
              SizedBox(width: 8),
              Tooltip(
                message: 'Sync from ntp server',
                preferBelow: false,
                verticalOffset: 22,
                child: OutlinedButton(
                  onPressed: () => {dateTimeController.syncNTP(), displayInfo('Synchronize Date & time by ${dateTimeController.referenceIdentifier.value}')},
                  child: Icon(Icons.sync, size: 16, color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text('Version: ${dateTimeController.version.value}'),
          Text('Mode: ${dateTimeController.mode.value}'),
          Text('Reference Identifier: ${dateTimeController.referenceIdentifier.value}'),
          Text('Poll: ${dateTimeController.poll.value}'),
          Text('Stratum: ${dateTimeController.stratum.value}'),
          Text('Leap Indicator: ${dateTimeController.leapIndicator.value}'),
          Text('Precision: ${dateTimeController.precision.value}'),
          Text('Root Delay: ${dateTimeController.rootDelay.value}'),
          Text('Root Dispersion: ${dateTimeController.rootDispersion.value}'),
          Text('Reference Timestamp: ${dateTimeController.referenceTimestamp.value}'),
          Text('Originate Timestamp: ${dateTimeController.originateTimestamp.value}'),
          Text('Receive Timestamp: ${dateTimeController.receiveTimestamp.value}'),
          Text('Transmit Timestamp: ${dateTimeController.transmitTimestamp.value}'),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    var now = DateTime.parse(dateTimeController.serverDate.value);
    var first = now.copyWith(year: now.year - 8);
    var last = now.copyWith(year: now.year + 9);
    showDatePicker(
      context: context,
      initialDate: DateTime.parse(dateTimeController.serverDate.value),
      firstDate: first,
      lastDate: last,
    ).then((value) => setState(() => {if (value != null) dateTimeController.serverDate.value = '${value.year}-${value.month}-${value.day.toString().padLeft(2, '0')}'}));
  }

  void _showTimePicker(BuildContext context) {
    var timeOfDay = TimeOfDay(hour: int.parse(dateTimeController.serverTime.value.split(':')[0]), minute: int.parse(dateTimeController.serverTime.value.split(':')[1]));
    showTimePicker(
      context: context,
      initialTime: timeOfDay,
    ).then((value) => setState(() => dateTimeController.serverTime.value = '${value!.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}:00'));
  }

  void switchToNtp(bool e) {
    dateTimeController.isNtpActive.value = e;
    if (e) {
      dateTimeController.fetchNtpInfo();
    } else {
      dateTimeController.fetchSystemDateTime();
    }
  }
}
