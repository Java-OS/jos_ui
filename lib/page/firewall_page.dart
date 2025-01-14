import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/controller/firewall_controller.dart';
import 'package:jos_ui/dialog/firewall/firewall_table_dialog.dart';
import 'package:jos_ui/dialog/host_dialog.dart';
import 'package:jos_ui/widget/tile_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FirewallPage extends StatefulWidget {
  const FirewallPage({super.key});

  @override
  State<FirewallPage> createState() => FirewallPageState();
}

class FirewallPageState extends State<FirewallPage> {
  final _firewallController = Get.put(FirewallController());

  @override
  void initState() {
    _firewallController.tableFetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContent(
      title: 'Firewall',
      controllers: [
        OutlinedButton(onPressed: () => displayFirewallTableModal(), child: Icon(Icons.add, size: 16, color: Colors.black)),
      ],
      child: SingleChildScrollView(
        child: Obx(
          () => ListView.builder(
            shrinkWrap: true,
            itemCount: _firewallController.firewallTables.length,
            itemBuilder: (context, index) {
              var table = _firewallController.firewallTables[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: TileItem(
                  onClick: () => print('Hello'),
                  actions: IconButton(
                    onPressed: () => _firewallController.tableDelete(table.handle),
                    splashRadius: 12,
                    icon: Icon(MdiIcons.trashCanOutline, size: 16, color: Colors.black),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.1), borderRadius: BorderRadius.circular(4), color: Colors.lightBlueAccent),
                      width: 50,
                      child: Center(
                        child: Text(
                          table.type.name,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  index: index,
                  title: Text(table.name),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<DataColumn> columns() {
    var idColumn = DataColumn(label: Text('id', style: TextStyle(fontWeight: FontWeight.bold)));
    var nameColumn = DataColumn(label: Text('name', style: TextStyle(fontWeight: FontWeight.bold)));
    var typeColumn = DataColumn(label: Text('type', style: TextStyle(fontWeight: FontWeight.bold)));
    var actionColumn = DataColumn(label: SizedBox.shrink());
    return [idColumn, nameColumn, typeColumn, actionColumn];
  }

  List<DataRow> rows() {
    var rowList = <DataRow>[];
    var tables = _firewallController.firewallTables;
    for (var item in tables) {
      var row = DataRow(
        cells: [
          DataCell(Text(item.handle.toString(), style: TextStyle(fontSize: 12))),
          DataCell(Text(item.name, style: TextStyle(fontSize: 12))),
          DataCell(Text(item.type.value, style: TextStyle(fontSize: 12))),
          DataCell(SizedBox.expand())
          // DataCell(
          //   Align(
          //     alignment: Alignment.centerLeft,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       children: [
          //         IconButton(onPressed: () => _networkController.removeHost(hostname), splashRadius: 14, splashColor: Colors.transparent, icon: Icon(MdiIcons.trashCanOutline, size: 16)),
          //       ],
          //     ),
          //   ),
          // )
        ],
      );
      rowList.add(row);
    }

    return rowList;
  }
}
