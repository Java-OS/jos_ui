import 'package:flutter/material.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/drop_down.dart';
import 'package:jos_ui/component/text_field_box.dart';
import 'package:jos_ui/controller/log_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';
import 'package:jos_ui/model/log_info.dart';
import 'package:jos_ui/model/log_level.dart';
import 'package:jos_ui/service/websocket/jvm_log_websocket_service.dart';
import 'package:xterm/ui.dart';

import '../service/websocket/container_log_websocket_service.dart';

var _logController = Get.put(LogController());
final _jvmLogWebsocketService = Get.put(JvmLogWebsocketService());
final _containerLogWebsocketService = Get.put(ContainerLogWebsocketService());

Future<void> displayLiveLoggerModal(LogInfo logInfo) async {
  _jvmLogWebsocketService.consumeEvents(logInfo.packageName);
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Obx(
          () => SizedBox(
            width: _jvmLogWebsocketService.isMaximize.value ? double.infinity : 800,
            height: _jvmLogWebsocketService.isMaximize.value ? double.infinity : 400,
            child: Stack(
              children: [
                TerminalView(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  _jvmLogWebsocketService.terminal,
                  controller: _jvmLogWebsocketService.terminalController,
                  autofocus: true,
                  textStyle: TerminalStyle(fontSize: 11, fontFamily: 'IBMPlexMono'),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    spacing: 4,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(_jvmLogWebsocketService.isConnected.value == true ? Iconic.pause : Iconic.play, color: Colors.white, size: 16),
                        onPressed: () => _jvmLogWebsocketService.isConnected.value == true ? _jvmLogWebsocketService.disconnectWebsocket() : _jvmLogWebsocketService.consumeEvents(logInfo.packageName),
                      ),
                      IconButton(
                        icon: Icon(Icons.clear_all, color: Colors.white, size: 16),
                        onPressed: () => _jvmLogWebsocketService.terminalReset(),
                      ),
                      IconButton(
                        icon: Icon(_jvmLogWebsocketService.isConnected.value == true ? LineariconsFree.frame_contract : LineariconsFree.frame_expand, color: Colors.white, size: 16),
                        onPressed: () => _jvmLogWebsocketService.isConnected.value = !_jvmLogWebsocketService.isConnected.value,
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white, size: 18),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  ).then((value) => _jvmLogWebsocketService.disconnectWebsocket()).then((_) => _jvmLogWebsocketService.terminalReset());
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
                DropDownMenu<LogLevel>(
                  requiredValue: true,
                  displayClearButton: false,
                  value: _logController.logLevel.value,
                  items: List.generate(LogLevel.values.length, (index) => DropdownMenuItem(value: LogLevel.values[index], child: Text(LogLevel.values[index].name))),
                  onChanged: (level) => _logController.logLevel.value = level,
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
  ).then((value) => _logController.clean());
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
                DropDownMenu<LogLevel>(
                  requiredValue: true,
                  displayClearButton: false,
                  value: _logController.logLevel.value,
                  items: List.generate(LogLevel.values.length, (index) => DropdownMenuItem(value: LogLevel.values[index], child: Text(LogLevel.values[index].name))),
                  onChanged: (level) => _logController.logLevel.value = level,
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
  ).then((value) => _logController.clean());
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

Future<void> displayContainerLogDialog(String containerName) async {
  _containerLogWebsocketService.consumeEvents(containerName);
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Obx(
          () => SizedBox(
            width: _containerLogWebsocketService.isMaximize.value ? double.infinity : 800,
            height: _containerLogWebsocketService.isMaximize.value ? double.infinity : 400,
            child: Stack(
              children: [
                TerminalView(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  _containerLogWebsocketService.terminal,
                  controller: _containerLogWebsocketService.terminalController,
                  autofocus: true,
                  textStyle: TerminalStyle(fontSize: 11, fontFamily: 'IBMPlexMono'),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    spacing: 4,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(_containerLogWebsocketService.isConnected.value == true ? Iconic.pause : Iconic.play, color: Colors.white, size: 16),
                        onPressed: () => _containerLogWebsocketService.isConnected.value == true ? _containerLogWebsocketService.disconnectWebsocket() : _containerLogWebsocketService.consumeEvents(containerName),
                      ),
                      IconButton(
                        icon: Icon(Icons.clear_all, color: Colors.white, size: 16),
                        onPressed: () => _containerLogWebsocketService.terminalReset(),
                      ),
                      IconButton(
                        icon: Icon(_containerLogWebsocketService.isMaximize.value == true ? LineariconsFree.frame_contract : LineariconsFree.frame_expand, color: Colors.white, size: 16),
                        onPressed: () => _containerLogWebsocketService.isMaximize.value = !_containerLogWebsocketService.isMaximize.value,
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white, size: 18),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  ).then((_) => _containerLogWebsocketService.disconnectWebsocket()).then((_) => _containerLogWebsocketService.terminalReset());
}
