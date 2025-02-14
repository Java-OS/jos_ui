import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/component/tile_widget.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/firewall_controller.dart';
import 'package:jos_ui/dialog/firewall/firewall_table_dialog.dart';
import 'package:jos_ui/model/firewall/table.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FirewallTablePage extends StatefulWidget {
  const FirewallTablePage({super.key});

  @override
  State<FirewallTablePage> createState() => FirewallTablePageState();
}

class FirewallTablePageState extends State<FirewallTablePage> {
  final _firewallController = Get.put(FirewallController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _firewallController.tableFetch());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContent(
      controllers: [
        OutlinedButton(onPressed: () => displayFirewallTableModal(false), child: Icon(Icons.add, size: 16, color: Colors.black)),
      ],
      child: Expanded(
        child: SingleChildScrollView(
          child: Obx(
            () => ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _firewallController.tableList.length,
              itemBuilder: (context, index) {
                var table = _firewallController.tableList[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TileItem(
                    onClick: () => gotoChainPage(table),
                    actions: SizedBox(
                      width: 100,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () => _firewallController.tableDelete(table.handle!),
                            splashRadius: 12,
                            icon: Icon(MdiIcons.trashCanOutline, size: 16, color: Colors.black),
                          ),
                          IconButton(
                            onPressed: () => renameTable(table),
                            splashRadius: 12,
                            icon: Icon(MdiIcons.pencil, size: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    leading: Container(
                      width: 70,
                      padding: EdgeInsets.only(left: 4, right: 4),
                      decoration: BoxDecoration(
                        color: Colors.brown,
                        border: Border.all(width: 0.1, color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Text(
                        table.type.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    index: index,
                    title: Text(table.name),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void renameTable(FirewallTable table) {
    _firewallController.tableNameEditingController.text = table.name;
    _firewallController.tableType.value = table.type;
    _firewallController.tableHandle.value = table.handle;
    displayFirewallTableModal(true);
  }

  Future<void> gotoChainPage(FirewallTable table) async {
    _firewallController.tableHandle.value = table.handle;
    await _firewallController.chainFetch();
    Get.toNamed(Routes.firewallChains.path, arguments: [table.name]);
  }
}
