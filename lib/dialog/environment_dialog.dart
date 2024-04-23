import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/environment_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';
import 'package:jos_ui/utils.dart';
import 'package:jos_ui/widget/text_field_box_widget.dart';

EnvironmentController _environmentController = Get.put(EnvironmentController());

Future<void> addEnvironment(BuildContext context) async {
  _displayModal(context, _environmentController.setSystemEnvironment);
}

Future<void> updateEnvironment(String value, BuildContext context) async {
  _environmentController.valueEditingController.text = value;
  _displayModal(context, _environmentController.updateEnvironment);
}

Future<void> _displayModal(BuildContext context, Function execute) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Environment'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [TextFieldBox(controller: _environmentController.keyEditingController, label: 'Key', isEnable: false), SizedBox(height: 8), TextFieldBox(controller: _environmentController.valueEditingController, label: 'Value'), SizedBox(height: 20), Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: () => execute(), child: Text('Apply')))],
          )
        ],
      );
    },
  );
}

Future<void> displayBatchEnvironment(ClipboardData? clipboard, BuildContext context) async {
  if (clipboard == null || clipboard.text == null) return;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Batch environment'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Container(
            constraints: BoxConstraints(maxHeight: 200, maxWidth: 450),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                border: TableBorder(
                  verticalInside: BorderSide(color: Colors.black12, width: 1),
                ),
                dataRowMinHeight: 12,
                dataRowMaxHeight: 28,
                columnSpacing: 25,
                columns: getEnvironmentColumns(),
                rows: getEnvironmentRows(clipboard.text!),
              ),
            ),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () => _environmentController.setSystemBatchEnvironment(),
              child: Text('Apply'),
            ),
          ),
        ],
      );
    },
  ).then((value) => _environmentController.fetchSystemEnvironments());
}

List<DataColumn> getEnvironmentColumns() {
  var keyColumn = DataColumn(label: Text('Key', style: TextStyle(fontWeight: FontWeight.bold)));
  var valueColumn = DataColumn(label: Text('Value', style: TextStyle(fontWeight: FontWeight.bold)));
  return [keyColumn, valueColumn];
}

List<DataRow> getEnvironmentRows(String clipboard) {
  List<String> filteredLines = parseBatchEnvironments(clipboard);
  _environmentController.batchEditingController.text = filteredLines.join('\n');

  var listItems = <DataRow>[];
  for (var line in filteredLines) {
    int equalSignIndex = line.indexOf('=');
    String key = line.substring(0, equalSignIndex).trim();
    String value = line.substring(equalSignIndex + 1).trim();

    var row = DataRow(
      cells: [
        DataCell(
          Tooltip(
            preferBelow: false,
            message: key,
            child: Text(truncateWithEllipsis(20, key), style: TextStyle(fontSize: 12)),
          ),
        ),
        DataCell(
          Tooltip(
            preferBelow: false,
            message: value,
            child: Text(truncateWithEllipsis(50, value), style: TextStyle(fontSize: 12)),
          ),
        ),
      ],
    );
    listItems.add(row);
  }
  return listItems;
}

List<String> parseBatchEnvironments(String clipboard) {
  List<String> lines = clipboard.split('\n');
  
  // Map to keep track of seen keys
  Map<String, String> seenKeys = {};
  
  // Filter out duplicates
  List<String> filteredLines = lines
      .where((element) => element.isNotEmpty)
      .where((line) {
    int equalSignIndex = line.indexOf('=');
    if (equalSignIndex != -1) {
      String key = line.substring(0, equalSignIndex).trim();
      String value = line.substring(equalSignIndex +  1).trim();
  
      // If the key is not already in the map, add it and keep the line
      if (!seenKeys.containsKey(key)) {
        seenKeys[key] = value;
        return true; // Keep this line
      }
    }
    return false; // Skip this line
  }).toList();
  return filteredLines;
}
