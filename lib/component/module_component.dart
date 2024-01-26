import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/module_controller.dart';
import 'package:jos_ui/widget/upload_file_button.dart';

class ModuleComponent extends StatefulWidget {
  const ModuleComponent({super.key});

  @override
  State<ModuleComponent> createState() => _ModuleComponentState();
}

class _ModuleComponentState extends State<ModuleComponent> {
  final ModuleController _moduleController = Get.put(ModuleController());

  @override
  void initState() {
    _moduleController.fetchModules();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlinedButton(onPressed: () => _moduleController.uploadModule(), child: Icon(Icons.add, size: 16, color: Colors.black)),
          SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                width: double.infinity,
                child: Obx(() => DataTable(dataRowMinHeight: 12, dataRowMaxHeight: 28, columnSpacing: 0, columns: getUserTableColumns(), rows: getUserTableRows())),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<DataColumn> getUserTableColumns() {
    var nameColumn = DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)));
    var versionColumn = DataColumn(label: Text('version', style: TextStyle(fontWeight: FontWeight.bold)));
    var actionColumn = DataColumn(label: Expanded(child: SizedBox.shrink()));
    return [nameColumn, versionColumn, actionColumn];
  }

  List<DataRow> getUserTableRows() {
    final resultList = <DataRow>[];
    for (final module in _moduleController.moduleList) {
      var name = module.name;
      var version = module.version;
      var isLock = module.lock;
      var isEnable = module.enable;
      var isActiveService = module.activeService;
      var containService = module.containService;
      var row = DataRow(cells: [
        DataCell(Text(name, style: TextStyle(fontSize: 12))),
        DataCell(Text(version, style: TextStyle(fontSize: 12))),
        DataCell(
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getLinkButton(name, version, isEnable, isLock, containService, isActiveService),
              getServiceButton(name, version, isActiveService, containService, isEnable),
              getDeleteButton(name, version, isLock),
            ],
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
      icon: Icon(Icons.delete, size: 16),
    );
  }

  Widget getServiceButton(String moduleName, String version, bool isActiveService, bool containService, bool isEnable) {
    return IconButton(
      onPressed: !isEnable || !containService ? null : () => isActiveService ? _moduleController.stopService(moduleName, version) : _moduleController.startService(moduleName, version),
      splashRadius: 10,
      splashColor: Colors.transparent,
      icon: Icon(isActiveService ? Icons.pause : Icons.play_arrow, size: 16),
    );
  }

  Widget getLinkButton(String moduleName, String version, bool isEnable, bool isLock, bool containService, bool isActiveService) {
    return IconButton(
      onPressed: (containService && isActiveService) || (isLock && isEnable) ? null : () => isEnable ? _moduleController.disableModule(moduleName, version) : _moduleController.enableModule(moduleName, version),
      splashRadius: 10,
      splashColor: Colors.transparent,
      icon: Icon(isEnable ? Icons.link_outlined : Icons.link_off_outlined, size: 16),
    );
  }
}
