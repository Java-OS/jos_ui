import 'package:flutter/material.dart';
import 'package:jos_ui/modal/network_routes_modal.dart';

class NetworkComponent extends StatefulWidget {
  const NetworkComponent({super.key});

  @override
  State<NetworkComponent> createState() => _NetworkComponentState();
}

class _NetworkComponentState extends State<NetworkComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                OutlinedButton(onPressed: () {}, child: Icon(Icons.add, size: 16, color: Colors.black)),
                SizedBox(width: 8),
                OutlinedButton(onPressed: () {}, child: Icon(Icons.delete, size: 16, color: Colors.black)),
                SizedBox(width: 8),
              ],
            ),
            OutlinedButton(onPressed: () => displayNetworkRoutesModal(context), child: Icon(Icons.alt_route_rounded, size: 16, color: Colors.black)),
          ],
        ),
        SizedBox(height: 8),
        SizedBox(width: double.infinity, child: DataTable(dataRowMinHeight: 12,dataRowMaxHeight: 28, columnSpacing: 0, columns: getNetworkInterfacesColumns(), rows: getNetworkInterfacesRows()))
      ],
    );
  }

  List<DataColumn> getNetworkInterfacesColumns() {
    var interfaceColumn = DataColumn(label: Expanded(child: Text('Interface', style: TextStyle(fontWeight: FontWeight.bold))));
    var addressColumn = DataColumn(label: Expanded(child: Text('Address', style: TextStyle(fontWeight: FontWeight.bold))));
    var netmaskColumn = DataColumn(label: Expanded(child: Text('Netmask', style: TextStyle(fontWeight: FontWeight.bold))));
    return [interfaceColumn, addressColumn, netmaskColumn];
  }

  List<DataRow> getNetworkInterfacesRows() {
    var eth0Info = DataRow(cells: const [
      DataCell(Text('eth0', style: TextStyle(fontSize: 12))),
      DataCell(Text('192.168.1.125', style: TextStyle(fontSize: 12))),
      DataCell(Text('255.255.255.0', style: TextStyle(fontSize: 12))),
    ]);
    var wlan0Info = DataRow(cells: const [
      DataCell(Text('wlan0', style: TextStyle(fontSize: 12))),
      DataCell(Text('10.10.10.125', style: TextStyle(fontSize: 12))),
      DataCell(Text('255.255.255.0', style: TextStyle(fontSize: 12))),
    ]);
    return [eth0Info, wlan0Info];
  }
}
