import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/network_controller.dart';
import 'package:jos_ui/dialog/network_dialog.dart';

class TabNetworks extends StatefulWidget {
  const TabNetworks({super.key});

  @override
  State<TabNetworks> createState() => _TabNetworksState();
}

class _TabNetworksState extends State<TabNetworks> {
  final networkController = Get.put(NetworkController());

  @override
  void initState() {
    networkController.fetchNetworks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Networks',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
        Divider(),
        OutlinedButton(
            onPressed: () => displayNetworkModal(context),
            child: Icon(Icons.add, size: 16, color: Colors.black)),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            width: double.infinity,
            child: Obx(
              () => DataTable(
                dataRowMinHeight: 22,
                dataRowMaxHeight: 32,
                columns: columns(),
                rows: rows(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<DataColumn> columns() {
    var indexColumn = DataColumn(
        label: Text('Index', style: TextStyle(fontWeight: FontWeight.bold)));
    var networkColumn = DataColumn(
        label: Text('Network', style: TextStyle(fontWeight: FontWeight.bold)));
    var nameColumn = DataColumn(
        label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)));
    var actionColumn = DataColumn(label: SizedBox.shrink());
    return [indexColumn, networkColumn, nameColumn, actionColumn];
  }

  List<DataRow> rows() {
    var rowList = <DataRow>[];
    var networks = networkController.networks;
    var i = 1;
    for (var name in networks.keys) {
      var network = networks[name] ?? '';
      var row = DataRow(
        cells: [
          DataCell(Text((i).toString(), style: TextStyle(fontSize: 12))),
          DataCell(Text(network, style: TextStyle(fontSize: 12))),
          DataCell(Text(name, style: TextStyle(fontSize: 12))),
          DataCell(
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () => networkController.removeNetwork(name),
                      splashRadius: 14,
                      splashColor: Colors.transparent,
                      icon: Icon(Icons.delete_rounded, size: 16)),
                ],
              ),
            ),
          )
        ],
      );
      rowList.add(row);
      i++;
    }

    return rowList;
  }
}
