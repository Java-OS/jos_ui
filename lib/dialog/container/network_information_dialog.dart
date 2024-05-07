import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/dialog/base_dialog.dart';
import 'package:jos_ui/model/container/network_info.dart';

Future<void> displayNetworkInfo(NetworkInfo ni) async {
  var columns = [
    DataColumn(label: Text('Key', style: TextStyle(fontWeight: FontWeight.bold))),
    DataColumn(label: Text('Value', style: TextStyle(fontWeight: FontWeight.bold))),
  ];

  var nameRow = DataRow(cells: [DataCell(Text('Name', style: TextStyle(fontSize: 12))), DataCell(Text(ni.name, style: TextStyle(fontSize: 12)))]);
  var interfaceRow = DataRow(cells: [DataCell(Text('Interface', style: TextStyle(fontSize: 12))), DataCell(Text(ni.networkInterface, style: TextStyle(fontSize: 12)))]);
  var subnetRow = DataRow(cells: [DataCell(Text('Subnet', style: TextStyle(fontSize: 12))), DataCell(Text(ni.subnets[0].subnet, style: TextStyle(fontSize: 12)))]);
  var gatewayRow = DataRow(cells: [DataCell(Text('Gateway', style: TextStyle(fontSize: 12))), DataCell(Text(ni.subnets[0].gateway, style: TextStyle(fontSize: 12)))]);
  var driverRow = DataRow(cells: [DataCell(Text('Driver', style: TextStyle(fontSize: 12))), DataCell(Text(ni.driver, style: TextStyle(fontSize: 12)))]);
  var dnsEnableRow = DataRow(cells: [DataCell(Text('DNS Activated', style: TextStyle(fontSize: 12))), DataCell(Text(ni.dnsEnabled.toString(), style: TextStyle(fontSize: 12)))]);
  var rows = <DataRow>[nameRow, interfaceRow, subnetRow, gatewayRow, driverRow, dnsEnableRow];

  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Network Information'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [DataTable(columns: columns, rows: rows)],
      );
    },
  );
}
