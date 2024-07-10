import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/controller/network_controller.dart';
import 'package:jos_ui/dialog/network_dialog.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NetworkNetworksPage extends StatefulWidget {
  const NetworkNetworksPage({super.key});

  @override
  State<NetworkNetworksPage> createState() => NetworkNetworksPageState();
}

class NetworkNetworksPageState extends State<NetworkNetworksPage> {
  final _networkController = Get.put(NetworkController());

  @override
  void initState() {
    _networkController.fetchNetworks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContent(
      title: 'Networks',
      controllers: [
        OutlinedButton(onPressed: () => displayNetworkModal(context), child: Icon(Icons.add, size: 16, color: Colors.black)),
      ],
      child: SingleChildScrollView(
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
    var networks = _networkController.networks;
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
                  IconButton(onPressed: () => _networkController.removeNetwork(name), splashRadius: 14, splashColor: Colors.transparent, icon: Icon(MdiIcons.trashCanOutline, size: 16)),
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
