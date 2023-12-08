import 'package:flutter/material.dart';
import 'package:jos_ui/modal/environment_modal.dart';

class EnvironmentComponent extends StatefulWidget {
  const EnvironmentComponent({super.key});

  @override
  State<EnvironmentComponent> createState() => EnvironmentComponentState();
}

class EnvironmentComponentState extends State<EnvironmentComponent> {
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
    var interfaceColumn = DataColumn(label: Text('Key', style: TextStyle(fontWeight: FontWeight.bold)));
    var addressColumn = DataColumn(label: Text('Value', style: TextStyle(fontWeight: FontWeight.bold)));
    var netmaskColumn = DataColumn(label: SizedBox.shrink());
    return [interfaceColumn, addressColumn, netmaskColumn];
  }

  List<DataRow> getEnvironmentRows() {
    var kv = {
      'name': 'ali',
      'family': 'hosseini',
      'age': '1',
      'phoneNumber': '1234',
      'city': 'tehran',
      'email': 'a@b.com',
      'username': 'ali123',
      'address': 'aa - bb - cc',
      'national_code': '453121345464',
      'home': 'HOME_PATH',
      'aaa': 'aaa',
      'bbb': 'bbb',
      'ccc': 'ccc',
      'ddd': 'ddd',
      'eee': 'eee',
      'fff': 'fff',
      'ggg': 'ggg',
      'hhh': 'hhh',
      'iii': 'iii',
      'jjj': 'jjj',
    };

    var listItems = <DataRow>[];

    kv.forEach((key, value) {
      var row = DataRow(cells: [
        DataCell(Text(key, style: TextStyle(fontSize: 12))),
        DataCell(Text(value, style: TextStyle(fontSize: 12))),
        DataCell(
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 80,
              child: Row(
                children: [
                  IconButton(onPressed: () {}, splashRadius: 12, icon: Icon(Icons.delete, size: 16, color: Colors.black)),
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
}