import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/network_side_menu_component.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/network_controller.dart';
import 'package:jos_ui/dialog/network_dialog.dart';
import 'package:jos_ui/page_base_content.dart';

class NetworkNetworksPage extends StatefulWidget {
  const NetworkNetworksPage({super.key});

  @override
  State<NetworkNetworksPage> createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkNetworksPage> {
  final networkController = Get.put(NetworkController());

  @override
  void initState() {
    networkController.fetchNetworks();
    super.initState();
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
                        OutlinedButton(onPressed: () => displayNetworkModal(context), child: Icon(Icons.add, size: 16, color: Colors.black)),
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
    var networkColumn = DataColumn(label: Text('Network', style: TextStyle(fontWeight: FontWeight.bold)));
    var nameColumn = DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)));
    var actionColumn = DataColumn(label: SizedBox.shrink());
    return [indexColumn, networkColumn, nameColumn, actionColumn];
  }

  List<DataRow> rows() {
    var rowList = <DataRow>[];
    var networks = networkController.networks;
    for (var i = 0; i < networks.length; i++) {
      var network = networks[i];
      var row = DataRow(
        cells: [
          DataCell(Text((i + 1).toString(), style: TextStyle(fontSize: 12))),
          DataCell(Text('${network.network}/${network.cidr}', style: TextStyle(fontSize: 12))),
          DataCell(Text(network.name, style: TextStyle(fontSize: 12))),
          DataCell(
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(onPressed: () => networkController.removeNetwork(network.id), splashRadius: 14, splashColor: Colors.transparent, icon: Icon(Icons.delete_rounded, size: 16)),
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
