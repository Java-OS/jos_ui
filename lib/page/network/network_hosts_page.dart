import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/network_side_menu_component.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/network_controller.dart';
import 'package:jos_ui/dialog/host_dialog.dart';
import 'package:jos_ui/page_base_content.dart';

class NetworkHostsPage extends StatefulWidget {
  const NetworkHostsPage({super.key});

  @override
  State<NetworkHostsPage> createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkHostsPage> {
  final networkController = Get.put(NetworkController());

  @override
  void initState() {
    super.initState();
    networkController.fetchHosts();
  }

  @override
  Widget build(BuildContext context) {
    return getPageContent(
      child: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NetworkSideMenuComponent(),
            Expanded(
              child: Container(
                color: componentBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OutlinedButton(onPressed: () => displayHostModal(context), child: Icon(Icons.add, size: 16, color: Colors.black)),
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
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> columns() {
    var indexColumn = DataColumn(label: Text('Index', style: TextStyle(fontWeight: FontWeight.bold)));
    var ipColumn = DataColumn(label: Text('Ip', style: TextStyle(fontWeight: FontWeight.bold)));
    var hostnameColumn = DataColumn(label: Text('Hostname', style: TextStyle(fontWeight: FontWeight.bold)));
    var actionColumn = DataColumn(label: SizedBox.shrink());
    return [indexColumn, ipColumn, hostnameColumn, actionColumn];
  }

  List<DataRow> rows() {
    var rowList = <DataRow>[];
    var hosts = networkController.hosts;
    for (var i = 0; i < hosts.length; i++) {
      var host = hosts[i];
      var row = DataRow(
        cells: [
          DataCell(Text((i + 1).toString(), style: TextStyle(fontSize: 12))),
          DataCell(Text(host.ip.toString(), style: TextStyle(fontSize: 12))),
          DataCell(Text(host.hostname.toString(), style: TextStyle(fontSize: 12))),
          DataCell(
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(onPressed: () => networkController.removeHost(host.id), splashRadius: 14, splashColor: Colors.transparent, icon: Icon(Icons.delete_rounded, size: 16)),
                ],
              ),
            ),
          )
        ],
      );
      rowList.add(row);
    }

    return rowList;
  }
}
