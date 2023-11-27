import 'package:flutter/material.dart';

class ModuleComponent extends StatefulWidget {
  const ModuleComponent({super.key});

  @override
  State<ModuleComponent> createState() => _ModuleComponentState();
}

class _ModuleComponentState extends State<ModuleComponent> {
  final _listUsers = [
    {'moduleName': 'm1:0.1', 'enable': true, 'lock': true,'active':true},
    {'moduleName': 'm2:2.1', 'enable': true, 'lock': true,'active':true},
    {'moduleName': 'm3:0.2', 'enable': true, 'lock': false,'active':false},
    {'moduleName': 'm4:0.5', 'enable': true, 'lock': false,'active':true},
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlinedButton(onPressed: () {}, child: Icon(Icons.add, size: 16, color: Colors.black)),
          SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                width: double.infinity,
                child: DataTable(dataRowMinHeight: 12, dataRowMaxHeight: 28, columnSpacing: 0, columns: getUserTableColumns(), rows: getUserTableRows()),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<DataColumn> getUserTableColumns() {
    var idColumn = DataColumn(label: Text('Module Name', style: TextStyle(fontWeight: FontWeight.bold)));
    var usernameColumn = DataColumn(label: Text('Enable', style: TextStyle(fontWeight: FontWeight.bold)));
    var realmBitColumn = DataColumn(label: Text('Lock', style: TextStyle(fontWeight: FontWeight.bold)));
    var lockColumn = DataColumn(label: Text('Active', style: TextStyle(fontWeight: FontWeight.bold)));
    var actionColumn = DataColumn(label: Expanded(child: SizedBox.shrink()));
    return [idColumn, usernameColumn, realmBitColumn, lockColumn, actionColumn];
  }

  List<DataRow> getUserTableRows() {
    final resultList = <DataRow>[];
    for (final user in _listUsers) {
      var moduleName = user['moduleName'].toString();
      var enable = user['enable'] as bool;
      var lock = user['lock'] as bool;
      var active = user['active'] as bool;
      var row = DataRow(cells: [
        DataCell(Text(moduleName, style: TextStyle(fontSize: 12))),
        DataCell(IconButton(onPressed: () {}, splashRadius: 14, splashColor: Colors.transparent, icon: Icon(lock ? Icons.remove_circle_outline : Icons.done_all, size: 16))),
        DataCell(Icon(lock ? Icons.lock : Icons.lock_open, size: 16)),
        DataCell(IconButton(onPressed: () {}, splashRadius: 14, splashColor: Colors.transparent, icon: Icon(active ? Icons.pause : Icons.play_arrow, size: 16))),
        DataCell(
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 80,
              child: Row(
                children: [
                  IconButton(onPressed: () {}, splashRadius: 14, splashColor: Colors.transparent, icon: Icon(Icons.delete, size: 16))
                ],
              ),
            ),
          ),
        ),
      ]);
      resultList.add(row);
    }

    return resultList;
  }
}
