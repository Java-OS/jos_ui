import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/controller/firewall_controller.dart';
import 'package:jos_ui/dialog/firewall/firewall_table_dialog.dart';
import 'package:jos_ui/widget/tile_widget.dart';
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
    _firewallController.tableFetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContent(
      controllers: [
        OutlinedButton(onPressed: () => displayFirewallTableModal(), child: Icon(Icons.add, size: 16, color: Colors.black)),
      ],
      child: SingleChildScrollView(
        child: Obx(
          () => ListView.builder(
            shrinkWrap: true,
            itemCount: _firewallController.firewallTables.length,
            itemBuilder: (context, index) {
              var table = _firewallController.firewallTables[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: TileItem(
                  onClick: () => print('Hello'),
                  actions: IconButton(
                    onPressed: () => _firewallController.tableDelete(table.handle),
                    splashRadius: 12,
                    icon: Icon(MdiIcons.trashCanOutline, size: 16, color: Colors.black),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.1), borderRadius: BorderRadius.circular(4), color: Colors.lightBlueAccent),
                      width: 50,
                      child: Center(
                        child: Text(
                          table.type.name,
                          style: TextStyle(color: Colors.white),
                        ),
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
    );
  }
}
