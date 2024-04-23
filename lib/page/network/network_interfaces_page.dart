import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/network_side_menu_component.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/network_controller.dart';
import 'package:jos_ui/dialog/network_ethernet_dialog.dart';
import 'package:jos_ui/dialog/network_routes_dialog.dart';
import 'package:jos_ui/model/network/ethernet.dart';
import 'package:jos_ui/page_base_content.dart';
import 'package:jos_ui/widget/char_button.dart';

class NetworkInterfacesPage extends StatefulWidget {
  const NetworkInterfacesPage({super.key});

  @override
  State<NetworkInterfacesPage> createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkInterfacesPage> {
  final _networkController = Get.put(NetworkController());

  @override
  void initState() {
    _networkController.fetchEthernets();
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
                        OutlinedButton(
                          onPressed: () => displayNetworkRoutesModal(context),
                          child: Icon(Icons.directions_outlined, size: 16, color: Colors.black),
                        ),
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> getNetworkInterfacesColumns() {
    var interfaceColumn = DataColumn(label: Expanded(child: Text('Interface', style: TextStyle(fontWeight: FontWeight.bold))));
    var macColumn = DataColumn(label: Expanded(child: Text('Mac', style: TextStyle(fontWeight: FontWeight.bold))));
    var ipColumn = DataColumn(label: Expanded(child: Text('Ip/cidr', style: TextStyle(fontWeight: FontWeight.bold))));
    var actionColumn = DataColumn(label: Expanded(child: SizedBox.shrink()));
    return [interfaceColumn, macColumn, ipColumn, actionColumn];
  }

  List<DataRow> getEthernetsRows() {
    return _networkController.ethernetList.map((e) => _mapEthernetToDataRow(e)).toList();
  }

  DataRow _mapEthernetToDataRow(Ethernet ethernet) {
    var ipCidr = ethernet.ip != null ? '${ethernet.ip}/${ethernet.cidr}' : '';
    return DataRow(
      cells: [
        DataCell(Text(ethernet.iface, style: TextStyle(fontSize: 12))),
        DataCell(Text(ethernet.mac ?? '', style: TextStyle(fontSize: 12))),
        DataCell(Text(ipCidr, style: TextStyle(fontSize: 12))),
        DataCell(
          Row(
            children: [
              Visibility(
                visible: ethernet.isUp,
                replacement: CharButton(
                  char: 'E',
                  textStyle: TextStyle(color: Colors.black, fontSize: 11),
                  toolTip: 'Click to enable',
                  onPressed: () => _networkController.ifUp(ethernet.iface),
                ),
                child: CharButton(
                  char: 'D',
                  toolTip: 'Click to disable',
                  onPressed: () => _networkController.ifDown(ethernet.iface),
                  textStyle: TextStyle(color: Colors.black, fontSize: 11),
                ),
              ),
              SizedBox(width: 4),
              CharButton(
                char: 'F',
                toolTip: 'Click to flush',
                onPressed: () => _networkController.flush(ethernet.iface),
                textStyle: TextStyle(color: Colors.black, fontSize: 11),
              ),
              IconButton(onPressed: () => displayEthernetConfig(ethernet, context), splashRadius: 14, splashColor: Colors.transparent, icon: Icon(Icons.edit, size: 16)),
            ],
          ),
        )
      ],
    );
  }
}
