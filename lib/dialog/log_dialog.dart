import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/sse_controller.dart';
import 'package:jos_ui/model/log_level.dart';
import 'package:jos_ui/widget/char_button.dart';
import 'package:jos_ui/widget/drop_down_widget.dart';
import 'package:jos_ui/widget/text_box_widget.dart';

final SSEController _sseController = Get.put(SSEController());
final ScrollController _scrollController = ScrollController();

Future<void> displayLoggerModal(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Log'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 300,
                    child: TextBox(
                      controller: _sseController.packageEditingController,
                      label: 'package name',
                      onSubmit: (e) => _sseController.connect(),
                    ),
                  ),
                  SizedBox(width: 8),
                  SizedBox(
                    height: 36,
                    width: 88,
                    child: Obx(
                      () => DropDownMenu<LogLevel>(
                        displayClearButton: false,
                        value: _sseController.logLevel.value,
                        hint: Text(_sseController.logLevel.value.name),
                        items: LogLevel.values.map((e) => DropdownMenuItem<LogLevel>(value: e, child: Text(e.name))).toList(),
                        onChanged: (value) => _sseController.changeLevel(value),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Obx(
                    () => CharButton(
                      size: 36,
                      backgroundColor: _sseController.isConnected.isFalse ? Colors.white : Colors.blueAccent,
                      textColor: _sseController.isConnected.isFalse ? Colors.black : Colors.white,
                      char: _sseController.isConnected.isFalse ? 'Start' : 'Stop',
                      onPressed: () => _sseController.isConnected.isFalse ? _sseController.connect() : _sseController.disconnect(false, false),
                    ),
                  ),
                  SizedBox(width: 8),
                  Obx(
                    () => CharButton(
                      size: 36,
                      backgroundColor: _sseController.isTail.isFalse ? Colors.white : Colors.blueAccent,
                      textColor: _sseController.isTail.isFalse ? Colors.black : Colors.white,
                      char: _sseController.isTail.isFalse ? 'Tail' : 'Scroll',
                      onPressed: () => _sseController.isTail.value = !_sseController.isTail.value,
                    ),
                  ),
                  SizedBox(width: 8),
                  CharButton(
                    size: 36,
                    char: 'Clear',
                    onPressed: () => _sseController.queue.clear(),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  width: 900,
                  height: 400,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    child: Obx(
                      () => DataTable(
                        dataRowMinHeight: 22,
                        dataRowMaxHeight: 32,
                        columnSpacing: 4,
                        columns: _getLogColumns(),
                        rows: _getLogRows(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      );
    },
  ).then((value) => _sseController.disconnect(true, true));
}

List<DataColumn> _getLogColumns() {
  var levelColumn = DataColumn(label: Text('Level', style: TextStyle(fontWeight: FontWeight.bold)));
  var dateTimeColumn = DataColumn(label: Expanded(child: Text('Date & Time', style: TextStyle(fontWeight: FontWeight.bold))));
  var threadIdColumn = DataColumn(label: Expanded(child: Text('Thread ID', style: TextStyle(fontWeight: FontWeight.bold))));
  var loggerColumn = DataColumn(label: Expanded(child: Text('Logger', style: TextStyle(fontWeight: FontWeight.bold))));
  var messageColumn = DataColumn(label: Expanded(child: Text('Message', style: TextStyle(fontWeight: FontWeight.bold))));
  return [levelColumn, dateTimeColumn, threadIdColumn, loggerColumn, messageColumn];
}

List<DataRow> _getLogRows() {
  var dataRowList = <DataRow>[];
  var list = _sseController.queue;
  if (list.isNotEmpty && _sseController.isTail.isTrue) _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  for (var log in list) {
    var level = log.level;
    var dateTime = log.dateTime;
    var thread = log.thread;
    var logger = log.logger.length > 25 ? '... ${log.logger.substring(log.logger.length - 25)}' : log.logger;
    var message = log.message.length > 30 ? '${log.message.substring(0, 30)} ... (truncated)' : log.message;

    var bgColor = switch (level) {
      LogLevel.info => Colors.white,
      LogLevel.warn => Colors.orangeAccent,
      LogLevel.debug => Colors.brown,
      LogLevel.error => Colors.redAccent,
      LogLevel.trace => Colors.purpleAccent,
      LogLevel.all => Colors.white,
    };

    var textColor = switch (level) {
      LogLevel.info => Colors.black,
      LogLevel.warn => Colors.black,
      LogLevel.debug => Colors.white,
      LogLevel.error => Colors.white,
      LogLevel.trace => Colors.white,
      LogLevel.all => Colors.black,
    };

    var row = DataRow(
      color: MaterialStateProperty.all(bgColor),
      cells: [
        DataCell(SizedBox(width: 40, child: Text(level.name, style: TextStyle(fontSize: 12, color: textColor)))),
        DataCell(SizedBox(width: 160, child: Text(dateTime.toString(), style: TextStyle(fontSize: 12, color: textColor)))),
        DataCell(Text(thread, style: TextStyle(fontSize: 12, color: textColor))),
        DataCell(Text(logger, style: TextStyle(fontSize: 12, color: textColor))),
        DataCell(Text(message, style: TextStyle(fontSize: 12, color: textColor))),
      ],
    );
    dataRowList.add(row);
  }
  return dataRowList;
}
