import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/environment_controller.dart';
import 'package:jos_ui/dialog/environment_dialog.dart';

class EnvironmentComponent extends StatefulWidget {
  const EnvironmentComponent({super.key});

  @override
  State<EnvironmentComponent> createState() => EnvironmentComponentState();
}

class EnvironmentComponentState extends State<EnvironmentComponent> {
  final EnvironmentController environmentController = Get.put(EnvironmentController());

  @override
  void initState() {
    super.initState();
    environmentController.fetchSystemEnvironments();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlinedButton(onPressed: () => displayAddUpdateEnvironmentModal(context), child: Icon(Icons.add, size: 16, color: Colors.black)),
          SizedBox(width  : 8),
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
                    columns: getEnvironmentColumns(),
                    rows: getEnvironmentRows(),
                  ),
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
    environmentController.environments.forEach((key, value) {
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
                  IconButton(onPressed: () => environmentController.deleteSystemEnvironment(key), splashRadius: 12, icon: Icon(Icons.delete, size: 16, color: Colors.black)),
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
