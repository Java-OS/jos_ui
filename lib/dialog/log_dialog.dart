import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/filesystem_controller.dart';
import 'package:jos_ui/controller/log_controller.dart';
import 'package:jos_ui/controller/oci_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';
import 'package:jos_ui/dialog/filesystem_dialog.dart';
import 'package:jos_ui/model/log_info.dart';
import 'package:jos_ui/model/log_level.dart';
import 'package:jos_ui/widget/char_button.dart';
import 'package:jos_ui/widget/drop_down_widget.dart';
import 'package:jos_ui/widget/tab_widget.dart';
import 'package:jos_ui/widget/text_field_box_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:xterm/core.dart';
import 'package:xterm/ui.dart';

var _logController = Get.put(LogController());
var _filesystemController = Get.put(FilesystemController());
var _containerController = Get.put(OciController());

Future<void> displayLiveLoggerModal(LogInfo? logInfo) async {
  if (logInfo != null) {
    _logController.packageEditingController.text = logInfo.packageName;
    _logController.patternEditingController.text = logInfo.pattern;
    _logController.logLevel.value = LogLevel.getValue(logInfo.level);
  }
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Log'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        children: [
          SizedBox(
            width: 800,
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 300,
                        child: TextFieldBox(
                          controller: _logController.packageEditingController,
                          label: 'package name',
                          onSubmit: (e) => _logController.connect(),
                        ),
                      ),
                      SizedBox(width: 8),
                      SizedBox(
                        height: 36,
                        width: 88,
                        child: Obx(
                          () => DropDownMenu<LogLevel>(
                            displayClearButton: false,
                            value: _logController.logLevel.value,
                            hint: Text(_logController.logLevel.value.name),
                            items: LogLevel.values.map((e) => DropdownMenuItem<LogLevel>(value: e, child: Text(e.name))).toList(),
                            onChanged: (value) => _logController.changeLevel(value),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Obx(
                        () => CharButton(
                          width: 36,
                          height: 36,
                          backgroundColor: _logController.isConnected.isFalse ? Colors.white : Colors.grey[500],
                          textStyle: TextStyle(color: _logController.isConnected.isFalse ? Colors.black : Colors.white, fontSize: 11),
                          char: _logController.isConnected.isFalse ? 'Start' : 'Stop',
                          onPressed: () => _logController.isConnected.isFalse ? _logController.connect() : _logController.disconnect(false, false),
                        ),
                      ),
                      SizedBox(width: 8),
                      CharButton(
                        width: 36,
                        height: 36,
                        char: 'Clear',
                        textStyle: TextStyle(fontSize: 11, color: Colors.black),
                        onPressed: () => _logController.terminal.buffer.clear(),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: TerminalView(
                    padding: EdgeInsets.only(top: 8,bottom: 8),
                    _logController.terminal,
                    controller: _logController.terminalController,
                    autofocus: true,
                    textStyle: TerminalStyle(fontSize: 11,fontFamily: 'IBMPlexMono'),
                  ),
                )
                // Expanded(
                //   child: Container(
                //     color: Colors.black,
                //     width: double.infinity,
                //     child: Theme(
                //       data: ThemeData(scrollbarTheme: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(Colors.white))),
                //       child: Padding(
                //         padding: EdgeInsets.all(4),
                //         child: Obx(
                //           () => SelectableText.rich(TextSpan(style: TextStyle(fontSize: 11), children: processLines())),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          )
        ],
      );
    },
  ).then((value) => _logController.disconnect(true, true));
}

Future<void> displayLoggerModal() async {
  _logController.fetchAppenders().then(
        (value) => showDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return AlertDialog(
              title: getModalHeader('Logs'),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              contentPadding: EdgeInsets.zero,
              titlePadding: EdgeInsets.zero,
              backgroundColor: secondaryColor,
              scrollable: true,
              content: SizedBox(
                width: 900,
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TabBox(
                    tabs: const [
                      TabItem(text: 'File', icon: Icons.file_copy_outlined, iconSize: 18, fontSize: 12, fontWeight: FontWeight.bold),
                      TabItem(text: 'Syslog', icon: Icons.terminal_rounded, iconSize: 18, fontSize: 12, fontWeight: FontWeight.bold),
                    ],
                    contents: [
                      Obx(() => fileLoggerTab(context)),
                      Obx(() => syslogLoggerTab(context)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
}

Widget fileLoggerTab(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 14.0, top: 8),
        child: OutlinedButton(onPressed: () => displayFileLogAppender(null), child: Icon(Icons.add, size: 16, color: Colors.black)),
      ),
      Padding(
        padding: EdgeInsets.all(4.0),
        child: SizedBox(
          width: 900,
          child: DataTable(
            dataRowMinHeight: 22,
            dataRowMaxHeight: 32,
            columnSpacing: 4,
            columns: _getLogInfoColumns('FILE'),
            rows: _getLogInfoRows('FILE', context),
          ),
        ),
      ),
    ],
  );
}

Widget syslogLoggerTab(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 14.0, top: 8),
        child: OutlinedButton(onPressed: () => displaySysLogAppender(null), child: Icon(Icons.add, size: 16, color: Colors.black)),
      ),
      Padding(
        padding: EdgeInsets.all(4.0),
        child: SizedBox(
          width: 900,
          child: DataTable(
            dataRowMinHeight: 22,
            dataRowMaxHeight: 32,
            columnSpacing: 4,
            columns: _getLogInfoColumns('SYSLOG'),
            rows: _getLogInfoRows('SYSLOG', context),
          ),
        ),
      ),
    ],
  );
}

List<DataColumn> _getLogInfoColumns(String type) {
  var columns = <DataColumn>[];

  var idColumn = DataColumn(label: Text('Id', style: TextStyle(fontWeight: FontWeight.bold)));
  var packageColumn = DataColumn(label: Text('Package', style: TextStyle(fontWeight: FontWeight.bold)));
  var patternColumn = DataColumn(label: Expanded(child: Text('Pattern', style: TextStyle(fontWeight: FontWeight.bold))));
  var levelColumn = DataColumn(label: Expanded(child: Text('Level', style: TextStyle(fontWeight: FontWeight.bold))));

  if (type == 'SYSLOG') {
    var hostColumn = DataColumn(label: Expanded(child: Text('Host', style: TextStyle(fontWeight: FontWeight.bold))));
    var portColumn = DataColumn(label: Expanded(child: Text('Port', style: TextStyle(fontWeight: FontWeight.bold))));
    var facilityColumn = DataColumn(label: Expanded(child: Text('Facility', style: TextStyle(fontWeight: FontWeight.bold))));
    columns.addAll([idColumn, packageColumn, patternColumn, levelColumn, hostColumn, portColumn, facilityColumn]);
  } else {
    var fileMaxSizeColumn = DataColumn(label: Expanded(child: Text('MFS (MB)', style: TextStyle(fontWeight: FontWeight.bold))));
    var fileTotalSizeColumn = DataColumn(label: Expanded(child: Text('TS (MB)', style: TextStyle(fontWeight: FontWeight.bold))));
    var fileMaxHistoryColumn = DataColumn(label: Expanded(child: Text('HC', style: TextStyle(fontWeight: FontWeight.bold))));
    columns.addAll([idColumn, packageColumn, patternColumn, levelColumn, fileMaxSizeColumn, fileTotalSizeColumn, fileMaxHistoryColumn]);
  }

  columns.add(DataColumn(label: Expanded(child: SizedBox.shrink())));
  return columns;
}

List<DataRow> _getLogInfoRows(String type, BuildContext context) {
  var dataRowList = <DataRow>[];
  var list = _logController.logAppenders.where((item) => item.type == type).toList();
  for (var logInfo in list) {
    if (type == 'SYSLOG') {
      var syslogRow = DataRow(
        cells: [
          DataCell(Text(logInfo.id.toString(), style: TextStyle(fontSize: 12, color: Colors.black))),
          DataCell(Text(logInfo.packageName, style: TextStyle(fontSize: 12, color: Colors.black))),
          DataCell(Text(logInfo.pattern, style: TextStyle(fontSize: 12, color: Colors.black))),
          DataCell(Text(logInfo.level, style: TextStyle(fontSize: 12, color: Colors.black))),
          DataCell(Text(logInfo.syslogHost!, style: TextStyle(fontSize: 12, color: Colors.black))),
          DataCell(Text(logInfo.syslogPort.toString(), style: TextStyle(fontSize: 12, color: Colors.black))),
          DataCell(Text(logInfo.syslogFacility!, style: TextStyle(fontSize: 12, color: Colors.black))),
          DataCell(
            Row(
              children: [
                IconButton(onPressed: () => displaySysLogAppender(logInfo), splashRadius: 12, splashColor: Colors.transparent, icon: Icon(MdiIcons.pencilOutline, size: 16)),
                IconButton(onPressed: () => displayLiveLoggerModal(logInfo), splashRadius: 12, splashColor: Colors.transparent, icon: Icon(Icons.receipt_long_rounded, size: 16)),
                IconButton(onPressed: () => _logController.removeAppender(logInfo.id), splashRadius: 12, splashColor: Colors.transparent, icon: Icon(MdiIcons.trashCanOutline, size: 16)),
              ],
            ),
          ),
        ],
      );
      dataRowList.add(syslogRow);
    } else {
      var row = DataRow(
        cells: [
          DataCell(Text(logInfo.id.toString(), style: TextStyle(fontSize: 12, color: Colors.black))),
          DataCell(Text(logInfo.packageName, style: TextStyle(fontSize: 12, color: Colors.black))),
          DataCell(Text(logInfo.pattern, style: TextStyle(fontSize: 12, color: Colors.black))),
          DataCell(Text(logInfo.level, style: TextStyle(fontSize: 12, color: Colors.black))),
          DataCell(Text(logInfo.fileMaxSize.toString(), style: TextStyle(fontSize: 12, color: Colors.black))),
          DataCell(Text(logInfo.fileTotalSize.toString(), style: TextStyle(fontSize: 12, color: Colors.black))),
          DataCell(Text(logInfo.fileMaxHistory.toString(), style: TextStyle(fontSize: 12, color: Colors.black))),
          DataCell(
            Row(
              children: [
                IconButton(onPressed: () => displayFileLogAppender(logInfo), splashRadius: 12, splashColor: Colors.transparent, icon: Icon(MdiIcons.pencilOutline, size: 16)),
                IconButton(onPressed: () => displayLiveLoggerModal(logInfo), splashRadius: 12, splashColor: Colors.transparent, icon: Icon(Icons.receipt_long_rounded, size: 16)),
                IconButton(onPressed: () => fetchTreeAndDisplay(logInfo.packageName), splashRadius: 12, splashColor: Colors.transparent, icon: Icon(Icons.folder_open, size: 16)),
                IconButton(onPressed: () => _logController.removeAppender(logInfo.id), splashRadius: 12, splashColor: Colors.transparent, icon: Icon(MdiIcons.trashCanOutline, size: 16)),
              ],
            ),
          )
        ],
      );

      dataRowList.add(row);
    }
  }
  return dataRowList;
}

fetchTreeAndDisplay(String package) {
  _filesystemController.fetchFilesystemTree('/logs/$package').then((value) => displayFilesystemTree(false, true));
}

Future<void> displayFileLogAppender(LogInfo? logInfo) async {
  if (logInfo != null) {
    _logController.idEditingController.text = logInfo.id.toString();
    _logController.packageEditingController.text = logInfo.packageName;
    _logController.patternEditingController.text = logInfo.pattern;
    _logController.logLevel.value = LogLevel.getValue(logInfo.level);
    _logController.fileMaxSizeEditingController.text = logInfo.fileMaxSize.toString();
    _logController.fileTotalSizeEditingController.text = logInfo.fileTotalSize.toString();
    _logController.fileMaxHistoryEditingController.text = logInfo.fileMaxHistory.toString();
  }
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('File Log appender'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Column(
              children: [
                TextFieldBox(controller: _logController.packageEditingController, label: 'Package'),
                SizedBox(height: 8),
                TextFieldBox(controller: _logController.patternEditingController, label: 'Pattern'),
                SizedBox(height: 8),
                Obx(
                  () => DropDownMenu<LogLevel>(
                    displayClearButton: false,
                    value: _logController.logLevel.value,
                    hint: Text(_logController.logLevel.value.name),
                    items: LogLevel.values.map((e) => DropdownMenuItem<LogLevel>(value: e, child: Text(e.name))).toList(),
                    onChanged: (value) => _logController.changeLevel(value),
                  ),
                ),
                SizedBox(height: 8),
                TextFieldBox(controller: _logController.fileMaxSizeEditingController, label: 'File max size'),
                SizedBox(height: 8),
                TextFieldBox(controller: _logController.fileTotalSizeEditingController, label: 'File total history'),
                SizedBox(height: 8),
                TextFieldBox(controller: _logController.fileMaxHistoryEditingController, label: 'History count'),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => _logController.addFileAppender(),
                    child: Text('Apply'),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    },
  ).then((value) => _logController.clear());
}

Future<void> displaySysLogAppender(LogInfo? logInfo) async {
  if (logInfo != null) {
    _logController.idEditingController.text = logInfo.id.toString();
    _logController.packageEditingController.text = logInfo.packageName;
    _logController.patternEditingController.text = logInfo.pattern;
    _logController.logLevel.value = LogLevel.getValue(logInfo.level);
    _logController.syslogHostEditingController.text = logInfo.syslogHost.toString();
    _logController.syslogPortEditingController.text = logInfo.syslogPort.toString();
    _logController.syslogFacilityEditingController.text = logInfo.syslogFacility.toString();
  }
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('File Log appender'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Column(
              children: [
                TextFieldBox(controller: _logController.packageEditingController, label: 'Package'),
                SizedBox(height: 8),
                TextFieldBox(controller: _logController.patternEditingController, label: 'Pattern'),
                SizedBox(height: 8),
                Obx(
                  () => DropDownMenu<LogLevel>(
                    displayClearButton: false,
                    value: _logController.logLevel.value,
                    hint: Text(_logController.logLevel.value.name),
                    items: LogLevel.values.map((e) => DropdownMenuItem<LogLevel>(value: e, child: Text(e.name))).toList(),
                    onChanged: (value) => _logController.changeLevel(value),
                  ),
                ),
                SizedBox(height: 8),
                TextFieldBox(controller: _logController.syslogHostEditingController, label: 'Syslog host'),
                SizedBox(height: 8),
                TextFieldBox(controller: _logController.syslogPortEditingController, label: 'Syslog port'),
                SizedBox(height: 8),
                TextFieldBox(controller: _logController.syslogFacilityEditingController, label: 'Syslog facility'),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => _logController.addSyslogAppender(),
                    child: Text('Apply'),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    },
  ).then((value) => _logController.clear());
}

Future<void> displaySystemLogDialog() async {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        title: getModalHeader('System Log'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        content: Container(
          width: 800,
          height: 400,
          color: Colors.black,
          child: Theme(
            data: ThemeData(scrollbarTheme: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(Colors.white))),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SelectableText(
                _logController.systemLog.value,
                maxLines: 150,
                style: TextStyle(fontSize: 11, color: Colors.white),
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<void> displayContainerLogDialog() async {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        title: getModalHeader('Container Log'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        content: Container(
          width: 800,
          height: 400,
          color: Colors.black,
          child: TerminalView(
            padding: EdgeInsets.only(top: 8,bottom: 8),
            _containerController.terminal,
            controller: _containerController.terminalController,
            autofocus: true,
            textStyle: TerminalStyle(fontSize: 11,fontFamily: 'IBMPlexMono'),
          ),
        ),
      );
    },
  ).then((_) => _containerController.closeStreamListener());
}
