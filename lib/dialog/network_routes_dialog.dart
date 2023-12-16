import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/network_controller.dart';

NetworkController _networkController = Get.put(NetworkController());

Future<void> displayNetworkRoutesModal(BuildContext context) async {
  _networkController.fetchRoutes();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Routes'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OutlinedButton(
                onPressed: () => displayAddNewRouteModal(context),
                child: Icon(Icons.route_outlined, size: 16, color: Colors.black),
              ),
              SizedBox(
                width: double.infinity,
                height: 400,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Obx(
                    () => DataTable(
                      dataRowMinHeight: 22,
                      dataRowMaxHeight: 32,
                      columns: _getNetworkRouteColumns(),
                      rows: _getNetworkRouteRows(),
                    ),
                  ),
                ),
              ),
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
  var dataRowList = <DataRow>[];
  var list = _networkController.routeList.value;
  for (var item in list) {
    var row = DataRow(cells: [
      DataCell(Text(item.id.toString(), style: TextStyle(fontSize: 12))),
      DataCell(Text(item.destination, style: TextStyle(fontSize: 12))),
      DataCell(Text(item.netmask, style: TextStyle(fontSize: 12))),
      DataCell(Text(item.gateway, style: TextStyle(fontSize: 12))),
      DataCell(Text(item.iface, style: TextStyle(fontSize: 12))),
      DataCell(Text(item.flags, style: TextStyle(fontSize: 12))),
      DataCell(Text(item.metrics.toString(), style: TextStyle(fontSize: 12))),
      DataCell(Text(item.mtu.toString(), style: TextStyle(fontSize: 12))),
      DataCell(Row(children: [
        IconButton(onPressed: () {}, splashRadius: 14, splashColor: Colors.transparent, icon: Icon(Icons.edit, size: 16)),
        IconButton(onPressed: () {}, splashRadius: 14, splashColor: Colors.transparent, icon: Icon(Icons.delete, size: 16))
      ])),
    ]);
    dataRowList.add(row);
  }
  return dataRowList;
}

Future<void> displayAddNewRouteModal(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: getModalHeader('Add new route'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        content: DefaultTabController(
          initialIndex: 0,
          length: 3,
          child: SizedBox(
            width: 550,
            height: 190,
            child: Scaffold(
              body: Column(
                children: [
                  TabBar(tabs: const [
                    Tab(child: Row(children: [Icon(Icons.double_arrow, color: Colors.black), SizedBox(width: 8), Text('Default Gateway', style: TextStyle(color: Colors.black))])),
                    Tab(child: Row(children: [Icon(Icons.computer, color: Colors.black), SizedBox(width: 8), Text('Host', style: TextStyle(color: Colors.black))])),
                    Tab(child: Row(children: [Icon(Icons.account_tree_outlined, color: Colors.black), SizedBox(width: 8), Text('Network', style: TextStyle(color: Colors.black))])),
                  ]),
                  Expanded(
                    child: TabBarView(
                      children: [
                        defaultGatewayTab(),
                        hostTab(),
                        networkTab(),
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

Widget defaultGatewayTab() {
  return Padding(
    padding: EdgeInsets.all(14.0),
    child: Column(
      children: [
        TextField(decoration: InputDecoration(label: Text('Address'), hintStyle: TextStyle(fontSize: 12))),
        SizedBox(height: 30),
        Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: () {}, child: Text('Apply')))
      ],
    ),
  );
}

Widget hostTab() {
  return Padding(
    padding: EdgeInsets.all(14.0),
    child: Column(
      children: [
        Row(
          children: const [
            Flexible(child: TextField(decoration: InputDecoration(label: Text('Address'), hintStyle: TextStyle(fontSize: 12)))),
            SizedBox(width: 8),
            Flexible(child: TextField(decoration: InputDecoration(label: Text('metrics'), hintStyle: TextStyle(fontSize: 12)))),
          ],
        ),
        SizedBox(height: 30),
        Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: () {}, child: Text('Apply')))
      ],
    ),
  );
}

Widget networkTab() {
  return Padding(
    padding: EdgeInsets.all(14.0),
    child: Column(
      children: [
        Row(
          children: const [
            Flexible(child: TextField(decoration: InputDecoration(label: Text('network'), hintStyle: TextStyle(fontSize: 12)))),
            SizedBox(width: 8),
            Flexible(child: TextField(decoration: InputDecoration(label: Text('netmask'), hintStyle: TextStyle(fontSize: 12)))),
            SizedBox(width: 8),
            Flexible(child: TextField(decoration: InputDecoration(label: Text('metrics'), hintStyle: TextStyle(fontSize: 12)))),
          ],
        ),
        SizedBox(height: 30),
        Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: () {}, child: Text('Apply')))
      ],
    ),
  );
}
