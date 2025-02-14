import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/drop_down_widget.dart';
import 'package:jos_ui/component/tab_widget.dart';
import 'package:jos_ui/component/text_field_box_widget.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/network_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';
import 'package:jos_ui/model/network/ethernet.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
                onPressed: () => displayAddNewRouteModal(),
                child: Icon(Icons.add, size: 16, color: Colors.black),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 300),
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
  var actionColumn = DataColumn(label: SizedBox.shrink());
  return [indexColumn, destinationColumn, netmaskColumn, gatewayColumn, interfaceColumn, flagsColumn, metricsColumn, mtuColumn, actionColumn];
}

List<DataRow> _getNetworkRouteRows() {
  var dataRowList = <DataRow>[];
  var list = _networkController.routeList;
  for (var item in list) {
    var isLock = item.isLock;
    var row = DataRow(cells: [
      DataCell(Text(item.index.toString(), style: TextStyle(fontSize: 12, color: isLock ? Colors.grey : Colors.black))),
      DataCell(Text(item.destination, style: TextStyle(fontSize: 12, color: isLock ? Colors.grey : Colors.black))),
      DataCell(Text(item.netmask, style: TextStyle(fontSize: 12, color: isLock ? Colors.grey : Colors.black))),
      DataCell(Text(item.gateway, style: TextStyle(fontSize: 12, color: isLock ? Colors.grey : Colors.black))),
      DataCell(Text(item.iface, style: TextStyle(fontSize: 12, color: isLock ? Colors.grey : Colors.black))),
      DataCell(Text(item.flags, style: TextStyle(fontSize: 12, color: isLock ? Colors.grey : Colors.black))),
      DataCell(Text(item.metrics.toString(), style: TextStyle(fontSize: 12, color: isLock ? Colors.grey : Colors.black))),
      DataCell(Text(item.mtu.toString(), style: TextStyle(fontSize: 12, color: isLock ? Colors.grey : Colors.black))),
      DataCell(Row(children: [IconButton(onPressed: isLock ? null : () => _networkController.deleteRoute(item.index), splashRadius: 14, splashColor: Colors.transparent, icon: Icon(MdiIcons.trashCanOutline, size: 16))])),
    ]);
    dataRowList.add(row);
  }
  return dataRowList;
}

Future<void> displayAddNewRouteModal() async {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Add new route'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        backgroundColor: secondaryColor,
        children: [
          TabBox(
            tabs: const [
              TabItem(text: 'Default Gateway', icon: Icons.double_arrow, iconSize: 18, fontSize: 12, fontWeight: FontWeight.bold),
              TabItem(text: 'Host', icon: Icons.computer, iconSize: 18, fontSize: 12, fontWeight: FontWeight.bold),
              TabItem(text: 'Network', icon: Icons.account_tree_outlined, iconSize: 18, fontSize: 12, fontWeight: FontWeight.bold),
            ],
            contents: [
              defaultGatewayTab(),
              hostTab(),
              networkTab(),
            ],
          ),
        ],
      );
    },
  );
}

Widget defaultGatewayTab() {
  return Padding(
    padding: EdgeInsets.all(14.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFieldBox(controller: _networkController.gatewayEditingController, label: 'Gateway'),
        SizedBox(height: 8),
        Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(onPressed: () => _networkController.addDefaultGateway(), child: Text('Apply')),
        ),
      ],
    ),
  );
}

Widget hostTab() {
  return Padding(
    padding: EdgeInsets.all(14.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFieldBox(controller: _networkController.addressEditingController, label: 'Address'),
        SizedBox(height: 8),
        TextFieldBox(controller: _networkController.gatewayEditingController, label: 'Gateway'),
        SizedBox(height: 8),
        Obx(
          () => DropDownMenu<Ethernet>(
            value: _networkController.routeSelectedEthernet.value,
            hint: Text('Interface'),
            items: _networkController.ethernetList.map((e) => DropdownMenuItem<Ethernet>(value: e, child: Text(e.iface))).toList(),
            onChanged: (value) => _networkController.routeSelectedEthernet.value = value,
          ),
        ),
        SizedBox(height: 8),
        TextFieldBox(controller: _networkController.metricsEditingController, label: 'metrics (optional [default: 600])'),
        SizedBox(height: 8),
        Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(onPressed: () => _networkController.addHostRoute(), child: Text('Apply')),
        ),
      ],
    ),
  );
}

Widget networkTab() {
  return Padding(
    padding: EdgeInsets.all(14.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFieldBox(controller: _networkController.networkEditingController, label: 'Network'),
        SizedBox(height: 8),
        TextFieldBox(controller: _networkController.netmaskEditingController, label: 'Netmask'),
        SizedBox(height: 8),
        TextFieldBox(controller: _networkController.gatewayEditingController, label: 'Gateway'),
        SizedBox(height: 8),
        Obx(
          () => DropDownMenu<Ethernet>(
            value: _networkController.routeSelectedEthernet.value,
            hint: Text('Interface'),
            items: _networkController.ethernetList.map((e) => DropdownMenuItem<Ethernet>(value: e, child: Text(e.iface))).toList(),
            onChanged: (value) => _networkController.routeSelectedEthernet.value = value,
          ),
        ),
        SizedBox(height: 8),
        TextFieldBox(controller: _networkController.metricsEditingController, label: 'metrics (optional [default: 600])'),
        SizedBox(height: 8),
        Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(onPressed: () => _networkController.addNetworkRoute(), child: Text('Apply')),
        ),
      ],
    ),
  );
}
