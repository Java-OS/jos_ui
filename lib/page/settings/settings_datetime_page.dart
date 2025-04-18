import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/component/text_field_box.dart';
import 'package:jos_ui/component/toast.dart';
import 'package:jos_ui/controller/date_time_controller.dart';
import 'package:searchfield/searchfield.dart';
import 'package:timezone/browser.dart';

class SettingsDatetimePage extends StatefulWidget {
  const SettingsDatetimePage({super.key});

  @override
  State<SettingsDatetimePage> createState() => _SettingsDatetimePageState();
}

class _SettingsDatetimePageState extends State<SettingsDatetimePage> {
  final _dateTimeController = Get.put(DateTimeController());
  late List<String> locations = [];
  bool mouseHoverTimeZone = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dateTimeController.fetchNtpInfo();
      _dateTimeController.fetchSystemDateTime();
    });
    var map = timeZoneDatabase.locations;
    for (String x in map.keys) {
      var name = map[x]!.name;
      var td = convertOffsetToTimeDifference(map[x]!.currentTimeZone.offset);
      locations.add('$name\t($td)');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContent(
      controllers: [
        Align(alignment: Alignment.bottomRight, child: ElevatedButton(onPressed: () => _dateTimeController.apply(), child: Text('Apply'))),
      ],
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            MouseRegion(
              onHover: (_) => setState(() => mouseHoverTimeZone = true),
              onExit: (_) => setState(() => mouseHoverTimeZone = false),
              child: Material(
                elevation: mouseHoverTimeZone ? 3 : 0,
                shadowColor: Colors.black,
                child: Obx(
                  () => SearchField(
                    suggestions: getCountries(),
                    controller: _dateTimeController.timeZoneEditingController,
                    hint: _dateTimeController.serverTimeZone.isEmpty ? 'Select timezone' : _dateTimeController.serverTimeZone.value,
                    onSubmit: (e) => _dateTimeController.updateTimezone(e),
                    onSuggestionTap: (e) => _dateTimeController.updateTimezone(e.searchKey),
                    searchInputDecoration: SearchInputDecoration(
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(fontSize: 12),
                      isDense: true,
                      contentPadding: EdgeInsets.all(14),
                    ),
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
                    Obx(() => Checkbox(value: _dateTimeController.isNtpActive.value, onChanged: (e) => switchToNtp(e!))),
                    SizedBox(width: 4),
                    Text('Set date and time automatically'),
                  ],
                ),
                Row(
                  children: [
                    Obx(
                      () => Visibility(
                        visible: !_dateTimeController.isNtpActive.value,
                        child: Tooltip(
                          message: 'Sync from hardware clock',
                          preferBelow: false,
                          verticalOffset: 22,
                          child: OutlinedButton(onPressed: () => _dateTimeController.hcToSys(), child: Icon(Icons.settings_backup_restore, size: 16)),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Tooltip(
                      message: 'Update hardware clock',
                      preferBelow: false,
                      verticalOffset: 22,
                      child: OutlinedButton(onPressed: () => _dateTimeController.sysToHc(), child: Icon(Icons.commit_rounded, size: 16)),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 4),
            Obx(
              () => Visibility(
                visible: _dateTimeController.isNtpActive.value,
                replacement: displayManualDateTimeComponent(),
                child: displayNtpComponent(),
              ),
            ),
          ],
        ),
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
          OutlinedButton(
              onPressed: () => _showDatePicker(context),
              child: Text(
                _dateTimeController.serverDate.value,
              )),
          SizedBox(width: 8),
          OutlinedButton(onPressed: () => _showTimePicker(context), child: Text(_dateTimeController.serverTime.value)),
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
              Flexible(child: TextFieldBox(controller: _dateTimeController.ntpServerEditingController, label: 'NTP server')),
              SizedBox(width: 8),
              Flexible(child: TextFieldBox(controller: _dateTimeController.ntpIntervalEditingController, label: 'Time interval (milliseconds)')),
              SizedBox(width: 8),
              Tooltip(
                message: 'Sync from ntp server',
                preferBelow: false,
                verticalOffset: 22,
                child: OutlinedButton(
                  onPressed: () => {_dateTimeController.syncNTP(), displayInfo('Synchronize Date & time by ${_dateTimeController.referenceIdentifier.value}')},
                  child: Icon(Icons.sync, size: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text('Version: ${_dateTimeController.version.value}'),
          Text('Mode: ${_dateTimeController.mode.value}'),
          Text('Reference Identifier: ${_dateTimeController.referenceIdentifier.value}'),
          Text('Poll: ${_dateTimeController.poll.value}'),
          Text('Stratum: ${_dateTimeController.stratum.value}'),
          Text('Leap Indicator: ${_dateTimeController.leapIndicator.value}'),
          Text('Precision: ${_dateTimeController.precision.value}'),
          Text('Root Delay: ${_dateTimeController.rootDelay.value}'),
          Text('Root Dispersion: ${_dateTimeController.rootDispersion.value}'),
          Text('Reference Timestamp: ${_dateTimeController.referenceTimestamp.value}'),
          Text('Originate Timestamp: ${_dateTimeController.originateTimestamp.value}'),
          Text('Receive Timestamp: ${_dateTimeController.receiveTimestamp.value}'),
          Text('Transmit Timestamp: ${_dateTimeController.transmitTimestamp.value}'),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    var now = DateTime.parse(_dateTimeController.serverDate.value);
    var first = now.copyWith(year: now.year - 8);
    var last = now.copyWith(year: now.year + 9);
    showDatePicker(
      context: context,
      initialDate: DateTime.parse(_dateTimeController.serverDate.value),
      firstDate: first,
      lastDate: last,
    ).then((value) => setState(() {
          if (value != null) {
            _dateTimeController.serverDate.value = '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
          }
        }));
  }

  void _showTimePicker(BuildContext context) {
    var timeOfDay = TimeOfDay(hour: int.parse(_dateTimeController.serverTime.value.split(':')[0]), minute: int.parse(_dateTimeController.serverTime.value.split(':')[1]));
    showTimePicker(
      context: context,
      initialTime: timeOfDay,
    ).then((value) => setState(() => _dateTimeController.serverTime.value = '${value!.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}:00'));
  }

  void switchToNtp(bool e) {
    _dateTimeController.isNtpActive.value = e;
    if (e) {
      _dateTimeController.fetchNtpInfo();
    } else {
      _dateTimeController.fetchSystemDateTime();
    }
  }

  String convertOffsetToTimeDifference(int offset) {
    final hours = offset ~/ 3600000;
    final minutes = (offset % 3600000) ~/ 60000;
    return '$hours:$minutes';
  }
}
