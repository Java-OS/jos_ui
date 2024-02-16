import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/date_time_controller.dart';
import 'package:jos_ui/dialog/toast.dart';
import 'package:jos_ui/widget/text_field_box_widget.dart';
import 'package:searchfield/searchfield.dart';
import 'package:timezone/browser.dart' as tz;

class DateTimeComponent extends StatefulWidget {
  const DateTimeComponent({super.key});

  @override
  State<DateTimeComponent> createState() => _DateTimeComponentState();
}

class _DateTimeComponentState extends State<DateTimeComponent> {
  final DateTimeController dateTimeController = Get.put(DateTimeController());

  late List<String> locations = [];
  bool mouseHoverTimeZone = false;

  String convertOffsetToTimeDifference(int offset) {
    final hours = offset ~/ 3600000;
    final minutes = (offset % 3600000) ~/ 60000;
    return '$hours:$minutes';
  }

  @override
  void initState() {
    super.initState();
    dateTimeController.fetchNtpInfo();
    var map = tz.timeZoneDatabase.locations;
    for (String x in map.keys) {
      var name = map[x]!.name;
      var td = convertOffsetToTimeDifference(map[x]!.currentTimeZone.offset);
      locations.add('$name\t($td)');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                MouseRegion(
                  onHover: (_) => setState(() => mouseHoverTimeZone = true),
                  onExit: (_) => setState(() => mouseHoverTimeZone = false),
                  child: Material(
                    elevation: mouseHoverTimeZone ? 3 : 0,
                    shadowColor: Colors.black,
                    child: SearchField(
                      suggestions: getCountries(),
                      controller: dateTimeController.timeZoneEditingController,
                      hint: 'Select timezone',
                      onSubmit: (e) => dateTimeController.updateTimezone(e),
                      onSuggestionTap: (e) => dateTimeController.updateTimezone(e.searchKey),
                      searchInputDecoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(fontSize: 12),
                        isDense: true,
                        contentPadding: EdgeInsets.all(14),
                      ),
                    ),
                  ),
                ),
                Divider(),
                SizedBox(height: 8),
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
          ),
          Align(alignment: Alignment.bottomRight, child: ElevatedButton(onPressed: () => dateTimeController.apply(), child: Text('Apply')))
        ],
      ),
    );
  }

  List<SearchFieldListItem<dynamic>> getCountries() {
    return locations
        .map(
          (e) => SearchFieldListItem(
            e,
            child: Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(e.split('\t')[0]), Text(e.split('\t')[1])],
              ),
            ),
          ),
        )
        .toList();
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
              Flexible(child: TextFieldBox(controller: dateTimeController.ntpServerEditingController, label: 'NTP server')),
              SizedBox(width: 8),
              Flexible(child: TextFieldBox(controller: dateTimeController.ntpIntervalEditingController, label: 'Time interval (milliseconds)')),
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
    ).then((value) => setState(() => {if (value != null) dateTimeController.serverDate.value = '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}'}));
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
