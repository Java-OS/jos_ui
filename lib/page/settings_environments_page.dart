import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/controller/environment_controller.dart';
import 'package:jos_ui/dialog/environment_dialog.dart';
import 'package:jos_ui/utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SettingsEnvironmentsPage extends StatefulWidget {
  const SettingsEnvironmentsPage({super.key});

  @override
  State<SettingsEnvironmentsPage> createState() => _SettingsEnvironmentsPageState();
}

class _SettingsEnvironmentsPageState extends State<SettingsEnvironmentsPage> {
  final _environmentController = Get.put(EnvironmentController());

  @override
  void initState() {
    _environmentController.fetchSystemEnvironments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContent(
      title: 'Environment Variables',
      controllers: [
        OutlinedButton(onPressed: () => displayAddEnvironmentDialog(_environmentController.keyEditingController, _environmentController.valueEditingController, _environmentController.setSystemEnvironment), child: Icon(Icons.add, size: 16, color: Colors.black)),
      ],
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
    );
  }

  List<DataColumn> getEnvironmentColumns() {
    var keyColumn = DataColumn(label: Text('Key', style: TextStyle(fontWeight: FontWeight.bold)));
    var valueColumn = DataColumn(label: Text('Value', style: TextStyle(fontWeight: FontWeight.bold)));
    var emptyColumn = DataColumn(label: SizedBox.shrink(), numeric: true);
    return [keyColumn, valueColumn, emptyColumn];
  }

  List<DataRow> getEnvironmentRows() {
    var listItems = <DataRow>[];
    _environmentController.environments.forEach((key, value) {
      var row = DataRow(cells: [
        DataCell(
          Tooltip(
            preferBelow: false,
            message: key,
            child: Text(truncateWithEllipsis(30, key), style: TextStyle(fontSize: 12)),
          ),
        ),
        DataCell(
          Tooltip(
            preferBelow: false,
            message: value,
            child: Text(truncateWithEllipsis(50, value), style: TextStyle(fontSize: 12)),
          ),
        ),
        DataCell(
          Container(
            padding: EdgeInsets.zero,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: () => displayUpdateEnvironmentDialog(_environmentController.keyEditingController, _environmentController.valueEditingController, key, value, _environmentController.updateEnvironment), splashRadius: 12, icon: Icon(MdiIcons.pencilOutline, size: 16, color: Colors.black)),
                IconButton(onPressed: () => _environmentController.deleteSystemEnvironment(key), splashRadius: 12, icon: Icon(MdiIcons.trashCanOutline, size: 16, color: Colors.black)),
              ],
            ),
          ),
        ),
      ]);
      listItems.add(row);
    });
    return listItems;
  }
}
