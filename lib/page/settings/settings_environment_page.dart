import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/settings_side_menu_component.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/environment_controller.dart';
import 'package:jos_ui/dialog/environment_dialog.dart';
import 'package:jos_ui/page_base_content.dart';
import 'package:jos_ui/utils.dart';

class SettingsEnvironmentPage extends StatefulWidget {
  const SettingsEnvironmentPage({super.key});

  @override
  State<SettingsEnvironmentPage> createState() => EnvironmentBasicPageState();
}

class EnvironmentBasicPageState extends State<SettingsEnvironmentPage> {
  final _environmentController = Get.put(EnvironmentController());

  @override
  void initState() {
    _environmentController.fetchSystemEnvironments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getPageContent(
      child: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsSideMenuComponent(),
            Expanded(
              child: Container(
                color: componentBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Basic Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
                      Divider(),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                OutlinedButton(onPressed: () => addEnvironment(context), child: Icon(Icons.add, size: 16, color: Colors.black)),
                                Tooltip(
                                  message: 'Paste from clipboard',
                                  preferBelow: false,
                                  verticalOffset: 22,
                                  child: OutlinedButton(onPressed: () => pasteFromClipboard(), child: Icon(Icons.paste, size: 16, color: Colors.black)),
                                ),
                              ],
                            ),
                            SizedBox(width: 8),
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
    _environmentController.environments.forEach((key, value) {
      var row = DataRow(cells: [
        DataCell(
          Tooltip(
            preferBelow: false,
            message: key,
            child: Text(truncateWithEllipsis(10, key), style: TextStyle(fontSize: 12)),
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
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 80,
              child: Row(
                children: [
                  IconButton(onPressed: () => _environmentController.deleteSystemEnvironment(key), splashRadius: 12, icon: Icon(Icons.delete, size: 16, color: Colors.black)),
                  IconButton(onPressed: () => updateEnvironment(value, context), splashRadius: 12, icon: Icon(Icons.edit, size: 16, color: Colors.black)),
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

  void pasteFromClipboard() {
    Clipboard.getData(Clipboard.kTextPlain).then((value) => displayBatchEnvironment(value, context));
  }
}
