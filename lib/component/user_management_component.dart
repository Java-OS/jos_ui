import 'package:flutter/material.dart';

class UserManagementComponent extends StatefulWidget {
  const UserManagementComponent({super.key});

  @override
  State<UserManagementComponent> createState() => _UserManagementComponentState();
}

class _UserManagementComponentState extends State<UserManagementComponent> {
  final _listUsers = [
    {'id': 1, 'username': 'admin', 'realmBit': 1023, 'lock': false},
    {'id': 2, 'username': 'mah454', 'realmBit': 64, 'lock': false},
    {'id': 3, 'username': 'javad', 'realmBit': 891, 'lock': true},
    {'id': 3, 'username': 'javad', 'realmBit': 891, 'lock': true},
    {'id': 3, 'username': 'javad', 'realmBit': 891, 'lock': true},
    {'id': 3, 'username': 'javad', 'realmBit': 891, 'lock': true},
    {'id': 3, 'username': 'javad', 'realmBit': 891, 'lock': true},
    {'id': 3, 'username': 'javad', 'realmBit': 891, 'lock': true},
    {'id': 3, 'username': 'javad', 'realmBit': 891, 'lock': true},
    {'id': 3, 'username': 'javad', 'realmBit': 891, 'lock': true},
    {'id': 3, 'username': 'javad', 'realmBit': 891, 'lock': true},
    {'id': 3, 'username': 'javad', 'realmBit': 891, 'lock': true},
    {'id': 3, 'username': 'javad', 'realmBit': 891, 'lock': true},
    {'id': 3, 'username': 'javad', 'realmBit': 891, 'lock': true},
    {'id': 3, 'username': 'javad', 'realmBit': 891, 'lock': true},
    {'id': 3, 'username': 'javad', 'realmBit': 891, 'lock': true},
    {'id': 3, 'username': 'javad', 'realmBit': 891, 'lock': true},
    {'id': 3, 'username': 'javad', 'realmBit': 891, 'lock': true},
    {'id': 3, 'username': 'javad', 'realmBit': 891, 'lock': true},
    {'id': 3, 'username': 'javad', 'realmBit': 891, 'lock': true},
    {'id': 3, 'username': 'javad', 'realmBit': 891, 'lock': true},
    {'id': 3, 'username': 'javad', 'realmBit': 891, 'lock': true},
    {'id': 3, 'username': 'javad', 'realmBit': 891, 'lock': true},
    {'id': 3, 'username': 'javad', 'realmBit': 891, 'lock': true},
    {'id': 3, 'username': 'javad', 'realmBit': 891, 'lock': true},
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
    var idColumn = DataColumn(label: Text('id', style: TextStyle(fontWeight: FontWeight.bold)));
    var usernameColumn = DataColumn(label: Text('Username', style: TextStyle(fontWeight: FontWeight.bold)));
    var realmBitColumn = DataColumn(label: Text('Realm Bit', style: TextStyle(fontWeight: FontWeight.bold)));
    var lockColumn = DataColumn(label: Text('lock', style: TextStyle(fontWeight: FontWeight.bold)));
    var actionColumn = DataColumn(label: Expanded(child: SizedBox.shrink()));
    return [idColumn, usernameColumn, realmBitColumn, lockColumn, actionColumn];
  }

  List<DataRow> getUserTableRows() {
    final resultList = <DataRow>[];
    for (final user in _listUsers) {
      var id = user['id'].toString();
      var username = user['username'].toString();
      var realmBit = user['realmBit'].toString();
      var lock = user['lock'].toString();
      var row = DataRow(cells: [
        DataCell(Text(id, style: TextStyle(fontSize: 12))),
        DataCell(Text(username, style: TextStyle(fontSize: 12))),
        DataCell(Text(realmBit, style: TextStyle(fontSize: 12))),
        DataCell(Text(lock, style: TextStyle(fontSize: 12))),
        DataCell(
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 80,
              child: Row(
                children: [
                  IconButton(onPressed: () {}, splashRadius: 14, splashColor: Colors.transparent, icon: Icon(Icons.edit, size: 16)),
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
