import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/system_controller.dart';
import 'package:jos_ui/dialog/system_dialog.dart';
import 'package:jos_ui/widget/text_field_box_widget.dart';

class BasicComponent extends StatefulWidget {
  const BasicComponent({super.key});

  @override
  State<BasicComponent> createState() => _BasicComponentState();
}

class _BasicComponentState extends State<BasicComponent> {
  final SystemController systemController = Get.put(SystemController());

  @override
  void initState() {
    super.initState();
    systemController.fetchHostname();
    systemController.fetchHosts();
    systemController.fetchDnsNameserver();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFieldBox(
              isEnable: false,
              isPassword: false,
              label: 'Hostname',
              controller: systemController.hostnameEditingController,
              onClick: () => displayHostnameModal(context),
            ),
            SizedBox(height: 16),
            TextFieldBox(
              isEnable: false,
              isPassword: false,
              label: 'DNS Nameserver',
              controller: systemController.dnsEditingController,
              onClick: () => displayDNSNameserverModal(context),
            ),
            SizedBox(height: 16),
            Text('Hosts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
            Divider(),
            Align(alignment: Alignment.centerLeft,child: OutlinedButton(onPressed: () => displayHostModal(context), child: Icon(Icons.add, size: 16, color: Colors.black))),
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
    var hosts = systemController.hosts;
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
                  IconButton(onPressed: () => systemController.removeHost(host.id), splashRadius: 14, splashColor: Colors.transparent, icon: Icon(Icons.delete_rounded, size: 16)),
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
