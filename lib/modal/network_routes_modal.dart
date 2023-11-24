import 'package:flutter/material.dart';

Future<void> displayNetworkRoutesModal(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: _getHeader(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedButton(onPressed: () {}, child: Icon(Icons.route_outlined, size: 16, color: Colors.black)),
            SizedBox(width: double.infinity, child: DataTable(dataRowMinHeight: 12, dataRowMaxHeight: 28, columns: _getNetworkRouteColumns(), rows: _getNetworkRouteRows())),
          ],
        ),
      );
    },
  );
}

Widget _getHeader() {
  return Container(
    width: double.infinity,
    height: 46,
    color: Colors.green,
    child: Padding(
      padding: const EdgeInsets.all(14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Routes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
          IconButton(onPressed: () {}, padding: EdgeInsets.zero, splashRadius: 10, icon: Icon(Icons.close, size: 22, color: Colors.white))
        ],
      ),
    ),
  );
}

List<DataColumn> _getNetworkRouteColumns() {
  var indexColumn = DataColumn(label: Expanded(child: Text('Index', style: TextStyle(fontWeight: FontWeight.bold))));
  var destinationColumn = DataColumn(label: Expanded(child: Text('Destination', style: TextStyle(fontWeight: FontWeight.bold))));
  var netmaskColumn = DataColumn(label: Expanded(child: Text('Netmask', style: TextStyle(fontWeight: FontWeight.bold))));
  var gatewayColumn = DataColumn(label: Expanded(child: Text('Gateway', style: TextStyle(fontWeight: FontWeight.bold))));
  var interfaceColumn = DataColumn(label: Expanded(child: Text('Interface', style: TextStyle(fontWeight: FontWeight.bold))));
  var flagsColumn = DataColumn(label: Expanded(child: Text('Flags', style: TextStyle(fontWeight: FontWeight.bold))));
  var metricsColumn = DataColumn(label: Expanded(child: Text('Metrics', style: TextStyle(fontWeight: FontWeight.bold))));
  var mtuColumn = DataColumn(label: Expanded(child: Text('MTU', style: TextStyle(fontWeight: FontWeight.bold))));
  return [indexColumn, destinationColumn, netmaskColumn, gatewayColumn, interfaceColumn, flagsColumn, metricsColumn, mtuColumn];
}

List<DataRow> _getNetworkRouteRows() {
  var eth0Info = DataRow(cells: const [
    DataCell(Text('1', style: TextStyle(fontSize: 12))),
    DataCell(Text('0.0.0.0', style: TextStyle(fontSize: 12))),
    DataCell(Text('0.0.0.0', style: TextStyle(fontSize: 12))),
    DataCell(Text('172.17.0.1', style: TextStyle(fontSize: 12))),
    DataCell(Text('eth0', style: TextStyle(fontSize: 12))),
    DataCell(Text('UG', style: TextStyle(fontSize: 12))),
    DataCell(Text('0', style: TextStyle(fontSize: 12))),
    DataCell(Text('0', style: TextStyle(fontSize: 12))),
  ]);
  var wlan0Info = DataRow(cells: const [
    DataCell(Text('2', style: TextStyle(fontSize: 12))),
    DataCell(Text('172.17.0.0', style: TextStyle(fontSize: 12))),
    DataCell(Text('255.255.0.0', style: TextStyle(fontSize: 12))),
    DataCell(Text('0.0.0.0', style: TextStyle(fontSize: 12))),
    DataCell(Text('eth0', style: TextStyle(fontSize: 12))),
    DataCell(Text('U', style: TextStyle(fontSize: 12))),
    DataCell(Text('0', style: TextStyle(fontSize: 12))),
    DataCell(Text('0', style: TextStyle(fontSize: 12))),
  ]);
  return [eth0Info, wlan0Info];
}
