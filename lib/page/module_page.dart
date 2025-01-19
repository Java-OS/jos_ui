import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/controller/module_controller.dart';
import 'package:jos_ui/dialog/log_dialog.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ModulePage extends StatefulWidget {
  const ModulePage({super.key});

  @override
  State<ModulePage> createState() => _ModulePageState();
}

class _ModulePageState extends State<ModulePage> {
  final _moduleController = Get.put(ModuleController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((e) => _moduleController.fetchModules());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContent(controllers: controllers(context), child: content());
  }

  Widget content() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: double.infinity,
        child: Obx(() => DataTable(dataRowMinHeight: 12, dataRowMaxHeight: 28, columnSpacing: 0, columns: getModuleTableColumns(), rows: getModuleTableRows())),
      ),
    );
  }

  List<Widget> controllers(BuildContext context) {
    return [
      OutlinedButton(
          onPressed: () => _moduleController.uploadModule(),
          child: Icon(
            Icons.add,
            size: 16,
            color: Colors.black,
          )),
      SizedBox(width: 8),
      OutlinedButton(
        onPressed: () => displayLoggerModal(),
        child: Icon(Icons.assignment_outlined, size: 16),
      ),
    ];
  }

  List<DataColumn> getModuleTableColumns() {
    var nameColumn = DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)));
    var versionColumn = DataColumn(label: Text('version', style: TextStyle(fontWeight: FontWeight.bold)));
    var actionColumn = DataColumn(label: Expanded(child: SizedBox.shrink()));
    return [nameColumn, versionColumn, actionColumn];
  }

  List<DataRow> getModuleTableRows() {
    final resultList = <DataRow>[];
    for (final module in _moduleController.moduleList) {
      var name = module.name;
      var version = module.version;
      var isLock = module.lock;
      var isEnable = module.enable;
      var isStarted = module.started;
      var isService = module.service;
      var row = DataRow(cells: [
        DataCell(Text(name, style: TextStyle(fontSize: 12))),
        DataCell(Text(version, style: TextStyle(fontSize: 12))),
        DataCell(
          Container(
            padding: EdgeInsets.zero,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                getLinkButton(name, version, isEnable, isLock, isService, isStarted),
                getServiceButton(name, version, isStarted, isService, isEnable),
                getDeleteButton(name, version, isLock),
              ],
            ),
          ),
        ),
      ]);
      resultList.add(row);
    }

    return resultList;
  }

  Widget getDeleteButton(String moduleName, String version, bool isLock) {
    return IconButton(
      onPressed: isLock ? null : () => _moduleController.removeModule(moduleName, version),
      splashRadius: 10,
      splashColor: Colors.transparent,
      icon: Icon(MdiIcons.trashCanOutline, size: 16),
    );
  }

  Widget getServiceButton(String moduleName, String version, bool isStarted, bool containService, bool isEnable) {
    return IconButton(
      onPressed: !isEnable || !containService ? null : () => isStarted ? _moduleController.stopService(moduleName, version) : _moduleController.startService(moduleName, version),
      splashRadius: 10,
      splashColor: Colors.transparent,
      icon: Icon(isStarted ? Icons.pause : Icons.play_arrow, size: 16),
    );
  }

  Widget getLinkButton(String moduleName, String version, bool isEnable, bool isLock, bool containService, bool isStarted) {
    return IconButton(
      onPressed: (containService && isStarted) || (isLock && isEnable) ? null : () => isEnable ? _moduleController.disableModule(moduleName, version) : _moduleController.enableModule(moduleName, version),
      splashRadius: 10,
      splashColor: Colors.transparent,
      icon: Icon(isEnable ? Icons.link_outlined : Icons.link_off_outlined, size: 16),
    );
  }

  Widget getLogButton() {
    return IconButton(
      onPressed: () => displayLoggerModal(),
      splashRadius: 10,
      splashColor: Colors.transparent,
      icon: Icon(Icons.assignment_outlined, size: 16),
    );
  }
}
