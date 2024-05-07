import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/dialog/base_dialog.dart';
import 'package:jos_ui/model/container/container_info.dart';

Future<void> displayContainerInfo(ContainerInfo ci) async {
  var columns = [
    DataColumn(label: Text('Key', style: TextStyle(fontWeight: FontWeight.bold))),
    DataColumn(label: Text('Value', style: TextStyle(fontWeight: FontWeight.bold))),
  ];

  var nameRow = DataRow(cells: [DataCell(Text('Name', style: TextStyle(fontSize: 12))), DataCell(Text(ci.names[0], style: TextStyle(fontSize: 12)))]);
  var stateRow = DataRow(cells: [DataCell(Text('State', style: TextStyle(fontSize: 12))), DataCell(Text(ci.state, style: TextStyle(fontSize: 12)))]);
  var idRow = DataRow(cells: [DataCell(Text('id', style: TextStyle(fontSize: 12))), DataCell(Text(ci.id, style: TextStyle(fontSize: 12)))]);
  var imageRow = DataRow(cells: [DataCell(Text('Image', style: TextStyle(fontSize: 12))), DataCell(Text(ci.image, style: TextStyle(fontSize: 12)))]);
  var imageIdRow = DataRow(cells: [DataCell(Text('Image ID', style: TextStyle(fontSize: 12))), DataCell(Text(ci.imageID, style: TextStyle(fontSize: 12)))]);
  var podRow = DataRow(cells: [DataCell(Text('Pod', style: TextStyle(fontSize: 12))), DataCell(Text(ci.pod, style: TextStyle(fontSize: 12)))]);
  var podNameRow = DataRow(cells: [DataCell(Text('Pod Name', style: TextStyle(fontSize: 12))), DataCell(Text(ci.podName, style: TextStyle(fontSize: 12)))]);
  var commandRow = DataRow(cells: [DataCell(Text('Command', style: TextStyle(fontSize: 12))), DataCell(Text(ci.command.toString(), style: TextStyle(fontSize: 12)))]);
  var autoRemoveRow = DataRow(cells: [DataCell(Text('Auto Remove', style: TextStyle(fontSize: 12))), DataCell(Text(ci.autoRemove.toString(), style: TextStyle(fontSize: 12)))]);
  var exitedRow = DataRow(cells: [DataCell(Text('Exited', style: TextStyle(fontSize: 12))), DataCell(Text(ci.exited.toString(), style: TextStyle(fontSize: 12)))]);
  var exitCodeRow = DataRow(cells: [DataCell(Text('Exit Code', style: TextStyle(fontSize: 12))), DataCell(Text(ci.exitCode.toString(), style: TextStyle(fontSize: 12)))]);
  var exitedAtRow = DataRow(cells: [DataCell(Text('Exit At', style: TextStyle(fontSize: 12))), DataCell(Text(ci.exitedAt.toString(), style: TextStyle(fontSize: 12)))]);
  var rows = <DataRow>[nameRow, stateRow, idRow, imageRow, imageIdRow, podRow, podNameRow, commandRow, autoRemoveRow, exitedRow, exitCodeRow, exitedAtRow];

  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Container Information'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 400,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(columns: columns, rows: rows),
            ),
          ),
        ],
      );
    },
  );
}
