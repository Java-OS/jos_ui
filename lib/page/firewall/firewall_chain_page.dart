import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContent(
      controllers: [
        OutlinedButton(onPressed: () => displayFirewallChainModal(false), child: Icon(Icons.add, size: 16, color: Colors.black)),
      ],
      child: SingleChildScrollView(
        child: Obx(
          () => ReorderableListView.builder(
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
                    onClick: () => print('Hello'),
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
                    subTitle: Row(
                      children: [
                        chainMetadata(chain.type?.name ?? 'Regular', Colors.white),
                        SizedBox(width: 8),
                        Visibility(visible: chain.hook != null, child: chainMetadata(chain.hook?.name ?? '', Colors.white)),
                        SizedBox(width: 8),
                        Visibility(visible: chain.policy != null, child: chainMetadata(chain.policy?.name ?? '', Colors.white)),
                        SizedBox(width: 8),
                      ],
                    ),
                    leading: CircleAvatar(
                      radius: 18,
                      child: Text(chain.handle.toString(), style: TextStyle(fontSize: 12)),
                    ),
                    index: index,
                    title: Text(chain.name),
                  ),
                ),
              );
            },
            onReorder: (int oldIndex, int newIndex) => updateOrder(oldIndex, newIndex),
          ),
        ),
      ),
    );
  }

  void updateOrder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) newIndex--;
      var chain = _firewallController.chainList.removeAt(oldIndex);
      _firewallController.chainList.insert(newIndex, chain);
      _firewallController.chainSwitch();
    });
  }

  Container chainMetadata(String text, Color color) {
    return Container(
      padding: EdgeInsets.only(left: 4, right: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(3)),
        border: Border.all(color: Colors.black45, width: 0.1),
      ),
      child: Text(text),
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
}
