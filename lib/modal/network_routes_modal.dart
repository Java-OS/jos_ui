import 'package:flutter/material.dart';
import 'package:jos_ui/constant.dart';

Future<void> displayNetworkRoutesModal(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: _getHeader('Routes'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OutlinedButton(onPressed: () => displayAddNewRouteModal(context), child: Icon(Icons.route_outlined, size: 16, color: Colors.black)),
              SizedBox(width: double.infinity, child: DataTable(dataRowMinHeight: 22, dataRowMaxHeight: 32, columns: _getNetworkRouteColumns(), rows: _getNetworkRouteRows())),
            ],
          )
        ],
      );
    },
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
  var actionColumn = DataColumn(label: Expanded(child: Text('actions', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))));
  return [indexColumn, destinationColumn, netmaskColumn, gatewayColumn, interfaceColumn, flagsColumn, metricsColumn, mtuColumn, actionColumn];
}

List<DataRow> _getNetworkRouteRows() {
  var eth0Info = DataRow(cells: [
    DataCell(Text('1', style: TextStyle(fontSize: 12))),
    DataCell(Text('0.0.0.0', style: TextStyle(fontSize: 12))),
    DataCell(Text('0.0.0.0', style: TextStyle(fontSize: 12))),
    DataCell(Text('172.17.0.1', style: TextStyle(fontSize: 12))),
    DataCell(Text('eth0', style: TextStyle(fontSize: 12))),
    DataCell(Text('UG', style: TextStyle(fontSize: 12))),
    DataCell(Text('0', style: TextStyle(fontSize: 12))),
    DataCell(Text('0', style: TextStyle(fontSize: 12))),
    DataCell(Row(children: [
      IconButton(onPressed: () {}, splashRadius: 14, splashColor: Colors.transparent, icon: Icon(Icons.edit, size: 16)),
      IconButton(onPressed: () {}, splashRadius: 14, splashColor: Colors.transparent, icon: Icon(Icons.delete, size: 16))
    ])),
  ]);
  var wlan0Info = DataRow(cells: [
    DataCell(Text('2', style: TextStyle(fontSize: 12))),
    DataCell(Text('172.17.0.0', style: TextStyle(fontSize: 12))),
    DataCell(Text('255.255.0.0', style: TextStyle(fontSize: 12))),
    DataCell(Text('0.0.0.0', style: TextStyle(fontSize: 12))),
    DataCell(Text('eth0', style: TextStyle(fontSize: 12))),
    DataCell(Text('U', style: TextStyle(fontSize: 12))),
    DataCell(Text('0', style: TextStyle(fontSize: 12))),
    DataCell(Text('0', style: TextStyle(fontSize: 12))),
    DataCell(Row(children: [
      IconButton(onPressed: () {}, splashRadius: 14, splashColor: Colors.transparent, icon: Icon(Icons.edit, size: 16)),
      IconButton(onPressed: () {}, splashRadius: 14, splashColor: Colors.transparent, icon: Icon(Icons.delete, size: 16))
    ])),
  ]);
  return [eth0Info, wlan0Info];
}

Future<void> displayAddNewRouteModal(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: _getHeader('Add new route'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        content: DefaultTabController(
          initialIndex: 0,
          length: 3,
          child: SizedBox(
            width: 550,
            height: 100,
            child: Scaffold(
              body: Column(
                children: const [
                  TabBar(tabs: [
                    Tab(child: Row(children: [Icon(Icons.double_arrow, color: Colors.black), SizedBox(width: 8), Text('Default Gateway', style: TextStyle(color: Colors.black))])),
                    Tab(child: Row(children: [Icon(Icons.computer, color: Colors.black), SizedBox(width: 8), Text('Host', style: TextStyle(color: Colors.black))])),
                    Tab(child: Row(children: [Icon(Icons.account_tree_outlined, color: Colors.black), SizedBox(width: 8), Text('Network', style: TextStyle(color: Colors.black))])),
                  ]),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Text('Default Gateway'),
                        Text('Host'),
                        Text('Network'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget _getHeader(String title) {
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
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
          IconButton(onPressed: () => _closeDialog(), padding: EdgeInsets.zero, splashRadius: 10, icon: Icon(Icons.close, size: 22, color: Colors.white))
        ],
      ),
    ),
  );
}

void _closeDialog() {
  navigatorKey.currentState?.pop();
}
