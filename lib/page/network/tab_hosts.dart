import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/network_controller.dart';
import 'package:jos_ui/dialog/host_dialog.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TabHosts extends StatefulWidget {
  const TabHosts({super.key});

  @override
  State<TabHosts> createState() => _TabHostsState();
}

class _TabHostsState extends State<TabHosts> {
  final networkController = Get.put(NetworkController());

  @override
  void initState() {
    super.initState();
    networkController.fetchHosts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hosts',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
        Divider(),
        OutlinedButton(
            onPressed: () => displayHostModal(context),
            child: Icon(Icons.add, size: 16, color: Colors.black)),
        SingleChildScrollView(
          child: Obx(
            () => DataTable(
              dataRowMinHeight: 22,
              dataRowMaxHeight: 32,
              columns: columns(),
              rows: rows(),
            ),
          ),
        ),
      ],
    );
  }

  List<DataColumn> columns() {
    var indexColumn = DataColumn(
        label: Text('Index', style: TextStyle(fontWeight: FontWeight.bold)));
    var ipColumn = DataColumn(
        label: Text('Ip', style: TextStyle(fontWeight: FontWeight.bold)));
    var hostnameColumn = DataColumn(
        label: Text('Hostname', style: TextStyle(fontWeight: FontWeight.bold)));
    var actionColumn = DataColumn(label: SizedBox.shrink());
    return [indexColumn, ipColumn, hostnameColumn, actionColumn];
  }

  List<DataRow> rows() {
    var rowList = <DataRow>[];
    var hosts = networkController.hosts;
    var i = 1;
    for (var ip in hosts.keys) {
      var hostname = hosts[ip] ?? '';
      var row = DataRow(
        cells: [
          DataCell(Text((i).toString(), style: TextStyle(fontSize: 12))),
          DataCell(Text(ip, style: TextStyle(fontSize: 12))),
          DataCell(Text(hostname, style: TextStyle(fontSize: 12))),
          DataCell(
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () => networkController.removeHost(hostname),
                      splashRadius: 14,
                      splashColor: Colors.transparent,
                      icon: Icon(MdiIcons.trashCanOutline, size: 16)),
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
