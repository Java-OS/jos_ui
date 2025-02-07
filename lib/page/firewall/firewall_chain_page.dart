import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/firewall_controller.dart';
import 'package:jos_ui/dialog/firewall/firewall_chain_dialog.dart';
import 'package:jos_ui/model/firewall/chain.dart';
import 'package:jos_ui/widget/tile_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FirewallChainPage extends StatefulWidget {
  const FirewallChainPage({super.key});

  @override
  State<FirewallChainPage> createState() => FirewallChainPageState();
}

class FirewallChainPageState extends State<FirewallChainPage> {
  final _firewallController = Get.put(FirewallController());

  @override
  void initState() {
    if (_firewallController.tableHandle.value == null) WidgetsBinding.instance.addPostFrameCallback((_) => Get.offAllNamed(Routes.firewallTables.routeName));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContent(
      controllers: [
        OutlinedButton(onPressed: () => displayFirewallChainModal(false), child: Icon(Icons.add, size: 16, color: Colors.black)),
      ],
      child: Expanded(
        child: SingleChildScrollView(
          child: Obx(
            () => ReorderableListView.builder(
              scrollDirection: Axis.vertical,
              buildDefaultDragHandles: false,
              proxyDecorator: (child, i, d) => child,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: _firewallController.chainList.length,
              itemBuilder: (context, index) {
                var chain = _firewallController.chainList[index];
                return Padding(
                  key: ValueKey(chain),
                  padding: const EdgeInsets.all(4.0),
                  child: ReorderableDragStartListener(
                    index: index,
                    child: TileItem(
                      onClick: () => gotoRulePage(chain),
                      actions: SizedBox(
                        width: 100,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () => _firewallController.chainDelete(chain.table.handle!, chain.handle!),
                              splashRadius: 12,
                              icon: Icon(MdiIcons.trashCanOutline, size: 16, color: Colors.black),
                            ),
                            IconButton(
                              onPressed: () => updateChain(chain),
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
                          color: Colors.green,
                          border: Border.all(width: 0.1, color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: Text(
                          chain.type?.name ?? 'regular',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      index: index,
                      title: Row(
                        spacing: 4,
                        children: [
                          Text(chain.name),
                          SizedBox(width: 12),
                          Visibility(visible: chain.hook != null, child: chainMetadata(chain.hook?.name ?? '', Colors.white)),
                          Visibility(visible: chain.policy != null, child: chainMetadata(chain.policy?.name ?? '', Colors.white)),
                        ],
                      ),
                    ),
                  ),
                );
              }, onReorder: (int oldIndex, int newIndex) => updateOrder(oldIndex, newIndex),
            ),
          ),
        ),
      ),
    );
  }

  Container chainMetadata(String text, Color color) {
    return Container(
      padding: EdgeInsets.only(left: 4, right: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(3)),
        border: Border.all(color: Colors.black45, width: 0.1),
      ),
      child: Text(text,style: TextStyle(color: Colors.black,fontSize: 12),),
    );
  }

  void updateChain(FirewallChain chain) {
    _firewallController.tableHandle.value = chain.table.handle;
    _firewallController.chainHandle.value = chain.handle;
    _firewallController.chainType.value = chain.type;
    _firewallController.chainHook.value = chain.hook;
    _firewallController.chainPolicy.value = chain.policy;
    _firewallController.chainPriority.value = chain.priority;
    _firewallController.chainNameEditingController.text = chain.name;

    displayFirewallChainModal(true);
  }

  Future<void> gotoRulePage(FirewallChain chain) async {
    _firewallController.ruleFetch(chain).then((_) => Get.toNamed(Routes.firewallRules.routeName));
  }

  void updateOrder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) newIndex--;
      var rule = _firewallController.chainList.removeAt(oldIndex);
      _firewallController.chainList.insert(newIndex, rule);
      _firewallController.chainSwitch();
    });
  }
}
