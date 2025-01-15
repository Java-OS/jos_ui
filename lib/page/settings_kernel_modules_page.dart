import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/controller/kernel_controller.dart';
import 'package:jos_ui/dialog/kernel_dialog.dart';
import 'package:jos_ui/model/kernel_mod_info.dart';
import 'package:jos_ui/utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SettingsKernelModulesPage extends StatefulWidget {
  const SettingsKernelModulesPage({super.key});

  @override
  State<SettingsKernelModulesPage> createState() => _SettingsKernelModulesPageState();
}

class _SettingsKernelModulesPageState extends State<SettingsKernelModulesPage> {
  final _kernelController = Get.put(KernelController());
  bool _sortAscending = true;

  @override
  void initState() {
    _kernelController.fetchKernelModules();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContent(
      controllers: [
        OutlinedButton(
          onPressed: () => displayAddKernelModuleDialog(_kernelController.loadKernelModule),
          child: Icon(Icons.add, size: 16),
        ),
      ],
      child: Obx(
        () => Expanded(
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                sortAscending: _sortAscending,
                sortColumnIndex: 0,
                dataRowMinHeight: 12,
                dataRowMaxHeight: 28,
                columnSpacing: 0,
                columns: getTableColumns(),
                rows: getTableRows(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> getTableColumns() {
    var nameColumn = DataColumn(
      onSort: (index, sortAscending) {
        setState(() => _sortAscending = sortAscending);
        if (!_sortAscending) {
          _kernelController.moduleList.sort((a, b) => a.name.compareTo(b.name));
        } else {
          _kernelController.moduleList.sort((a, b) => b.name.compareTo(a.name));
        }
      },
      label: Text('name', style: TextStyle(fontWeight: FontWeight.bold)),
    );
    var sizeColumn = DataColumn(label: Text('size', style: TextStyle(fontWeight: FontWeight.bold)));
    var usedByColumn = DataColumn(label: Text('used by', style: TextStyle(fontWeight: FontWeight.bold)));
    var usedByModulesColumn = DataColumn(label: Text('used by modules', style: TextStyle(fontWeight: FontWeight.bold)));
    var emptyColumn = DataColumn(label: SizedBox.shrink(), numeric: true);
    return [nameColumn, sizeColumn, usedByColumn, usedByModulesColumn, emptyColumn];
  }

  List<DataRow> getTableRows() {
    return _kernelController.moduleList.map((e) => _mapModuleInfoToDataRow(e)).toList();
  }

  DataRow _mapModuleInfoToDataRow(KernelModInfo kernelModInfo) {
    return DataRow(
      cells: [
        DataCell(Text(kernelModInfo.name, style: TextStyle(fontSize: 12))),
        DataCell(Text(kernelModInfo.size.toString(), style: TextStyle(fontSize: 12))),
        DataCell(Text(kernelModInfo.usedBy.toString(), style: TextStyle(fontSize: 12))),
        DataCell(
          Tooltip(
            preferBelow: false,
            message: kernelModInfo.usedByModules,
            child: Text(truncateWithEllipsis(50, kernelModInfo.usedByModules), style: TextStyle(fontSize: 12)),
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
                  onPressed: kernelModInfo.usedBy != 0 ? null : () => _kernelController.unloadKernelModule(kernelModInfo.name),
                  splashRadius: 12,
                  icon: Icon(MdiIcons.trashCanOutline, size: 16),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
