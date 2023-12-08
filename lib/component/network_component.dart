import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jos_ui/modal/network_routes_modal.dart';
import 'package:jos_ui/model/ethernet.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/service/rest_api_service.dart';

class NetworkComponent extends StatefulWidget {
  const NetworkComponent({super.key});

  @override
  State<NetworkComponent> createState() => _NetworkComponentState();
}

class _NetworkComponentState extends State<NetworkComponent> {
  List<Ethernet> ethernetList = [];

  @override
  void initState() {
    super.initState();
    _fetchEthernets();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Row(
          //       children: [
          //         OutlinedButton(onPressed: () {}, child: Icon(Icons.add, size: 16, color: Colors.black)),
          //         SizedBox(width: 8),
          //         OutlinedButton(onPressed: () {}, child: Icon(Icons.delete, size: 16, color: Colors.black)),
          //         SizedBox(width: 8),
          //       ],
          //     ),
          //     OutlinedButton(onPressed: () => displayNetworkRoutesModal(context), child: Icon(Icons.alt_route_rounded, size: 16, color: Colors.black)),
          //   ],
          // ),
          // SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                width: double.infinity,
                child: DataTable(
                  dataRowMinHeight: 12,
                  dataRowMaxHeight: 28,
                  columnSpacing: 0,
                  columns: getNetworkInterfacesColumns(),
                  rows: getEthernetsRows(),
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
    return ethernetList.map((e) => _mapEthernetToDataRow(e)).toList();
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

  Future<void> _fetchEthernets() async {
    var response = await RestClient.rpc(RPC.networkEthernetInformation, context, parameters: {'ethernet': ''});
    if (response != null) {
      var json = jsonDecode(response);
      var result = json['result'] as List;
      debugPrint(result.toString());
      setState(() {
        ethernetList = result.map((item) => Ethernet.fromJson(item)).toList();
      });
    }
  }
}
