import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/modal/environment_modal.dart';
import 'package:jos_ui/modal/toast.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/service/RpcProvider.dart';

class EnvironmentComponent extends StatefulWidget {
  const EnvironmentComponent({super.key});

  @override
  State<EnvironmentComponent> createState() => EnvironmentComponentState();
}

class EnvironmentComponentState extends State<EnvironmentComponent> {
  Map<String, String> _environments = {};

  @override
  void initState() {
    super.initState();
    _fetchSystemEnvironments();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlinedButton(onPressed: () => displayAddUpdateEnvironmentModal(context), child: Icon(Icons.add, size: 16, color: Colors.black)),
          SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                width: double.infinity,
                child: DataTable(
                  dataRowMinHeight: 12,
                  dataRowMaxHeight: 28,
                  columnSpacing: 0,
                  columns: getEnvironmentColumns(),
                  rows: getEnvironmentRows(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<DataColumn> getEnvironmentColumns() {
    var keyColumn = DataColumn(label: Text('Key', style: TextStyle(fontWeight: FontWeight.bold)));
    var valueColumn = DataColumn(label: Text('Value', style: TextStyle(fontWeight: FontWeight.bold)));
    var emptyColumn = DataColumn(label: SizedBox.shrink());
    return [keyColumn, valueColumn, emptyColumn];
  }

  List<DataRow> getEnvironmentRows() {
    var listItems = <DataRow>[];
    _environments.forEach((key, value) {
      var row = DataRow(cells: [
        DataCell(Text(truncateWithEllipsis(15, key), style: TextStyle(fontSize: 12))),
        DataCell(Text(truncateWithEllipsis(30, value), style: TextStyle(fontSize: 12))),
        DataCell(
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 80,
              child: Row(
                children: [
                  IconButton(onPressed: () => _deleteSystemEnvironment(key), splashRadius: 12, icon: Icon(Icons.delete, size: 16, color: Colors.black)),
                  IconButton(onPressed: () {}, splashRadius: 12, icon: Icon(Icons.edit, size: 16, color: Colors.black)),
                ],
              ),
            ),
          ),
        ),
      ]);
      listItems.add(row);
    });
    return listItems;
  }

  Future<void> _fetchSystemEnvironments() async {
    developer.log('Fetch System Environments called');
    var response = await RestClient.rpc(RPC.systemEnvironmentList);
    if (response != null) {
      var json = jsonDecode(response);
      setState(() => _environments = Map.from(json['result']));
    }
  }

  Future<void> _deleteSystemEnvironment(String key) async {
    developer.log('Delete System Environments called');
    await RestClient.rpc(RPC.systemEnvironmentUnset, parameters: {'key': key}).then((value) => _fetchSystemEnvironments());
    if (context.mounted) displayInfo('delete environment %s');
  }
}
