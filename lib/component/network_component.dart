import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/network_controller.dart';
import 'package:jos_ui/dialog/network_routes_dialog.dart';
import 'package:jos_ui/model/network/ethernet.dart';

class NetworkComponent extends StatefulWidget {
  const NetworkComponent({super.key});

  @override
  State<NetworkComponent> createState() => _NetworkComponentState();
}

class _NetworkComponentState extends State<NetworkComponent> {
  final NetworkController networkController = Get.put(NetworkController());

  @override
  void initState() {
    super.initState();
    networkController.fetchEthernets();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlinedButton(onPressed: () => displayNetworkRoutesModal(context), child: Icon(Icons.alt_route_rounded, size: 16, color: Colors.black)),
          SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                width: double.infinity,
                child: Obx(
                  () => DataTable(
                    dataRowMinHeight: 12,
                    dataRowMaxHeight: 28,
                    columnSpacing: 0,
                    columns: getNetworkInterfacesColumns(),
                    rows: getEthernetsRows(),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<DataColumn> getNetworkInterfacesColumns() {
    var interfaceColumn = DataColumn(label: Expanded(child: Text('Iface', style: TextStyle(fontWeight: FontWeight.bold))));
    var macColumn = DataColumn(label: Expanded(child: Text('Mac', style: TextStyle(fontWeight: FontWeight.bold))));
    var ipColumn = DataColumn(label: Expanded(child: Text('Ip', style: TextStyle(fontWeight: FontWeight.bold))));
    var netmaskColumn = DataColumn(label: Expanded(child: Text('Netmask', style: TextStyle(fontWeight: FontWeight.bold))));
    var cidrColumn = DataColumn(label: Expanded(child: Text('CIDR', style: TextStyle(fontWeight: FontWeight.bold))));
    return [interfaceColumn, macColumn, ipColumn, netmaskColumn, cidrColumn];
  }

  List<DataRow> getEthernetsRows() {
    return networkController.ethernetList.map((e) => _mapEthernetToDataRow(e)).toList();
  }

  DataRow _mapEthernetToDataRow(Ethernet ethernet) {
    return DataRow(cells: [
      DataCell(Text(ethernet.iface, style: TextStyle(fontSize: 12))),
      DataCell(Text(ethernet.mac ?? '', style: TextStyle(fontSize: 12))),
      DataCell(Text(ethernet.ip ?? '', style: TextStyle(fontSize: 12))),
      DataCell(Text(ethernet.netmask ?? '', style: TextStyle(fontSize: 12))),
      DataCell(Text(ethernet.cidr ?? '', style: TextStyle(fontSize: 12))),
    ]);
  }
}
