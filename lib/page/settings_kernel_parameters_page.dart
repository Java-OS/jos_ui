import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/controller/kernel_controller.dart';
import 'package:jos_ui/dialog/kernel_dialog.dart';
import 'package:jos_ui/utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SettingsKernelParametersPage extends StatefulWidget {
  const SettingsKernelParametersPage({super.key});

  @override
  State<SettingsKernelParametersPage> createState() => _SettingsKernelParametersPageState();
}

class _SettingsKernelParametersPageState extends State<SettingsKernelParametersPage> {
  final _kernelController = Get.put(KernelController());

  @override
  void initState() {
    _kernelController.fetchConfiguredKernelParameters();
    _kernelController.fetchKernelParameters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContent(
      controllers: [
        OutlinedButton(
          onPressed: () => displayAddKernelParameterDialog(_kernelController.setKernelParameter),
          child: Icon(Icons.add, size: 16, color: Colors.black),
        ),
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
              columns: getTableColumns(),
              rows: getTableRows(),
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> getTableColumns() {
    var keyColumn = DataColumn(label: Text('Parameter', style: TextStyle(fontWeight: FontWeight.bold)));
    var valueColumn = DataColumn(label: Text('Value', style: TextStyle(fontWeight: FontWeight.bold)));
    var emptyColumn = DataColumn(label: SizedBox.shrink(), numeric: true);
    return [keyColumn, valueColumn, emptyColumn];
  }

  List<DataRow> getTableRows() {
    var listItems = <DataRow>[];
    _kernelController.configuredKernelParameters.forEach((key, value) {
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
                IconButton(
                  onPressed: () => displayUpdateKernelParameterDialog(key, value, _kernelController.unsetKernelParameter),
                  splashRadius: 12,
                  icon: Icon(MdiIcons.pencilOutline, size: 16, color: Colors.black),
                ),
                IconButton(onPressed: () => _kernelController.unsetKernelParameter(key), splashRadius: 12, icon: Icon(MdiIcons.trashCanOutline, size: 16)),
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
