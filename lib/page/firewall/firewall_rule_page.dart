import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/firewall_controller.dart';
import 'package:jos_ui/dialog/firewall/firewall_rule_dialog.dart';
import 'package:jos_ui/model/firewall/rule.dart';
import 'package:jos_ui/widget/tile_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FirewallRulePage extends StatefulWidget {
  const FirewallRulePage({super.key});

  @override
  State<FirewallRulePage> createState() => FirewallRulePageState();
}

class FirewallRulePageState extends State<FirewallRulePage> {
  final _firewallController = Get.put(FirewallController());
  final Map<int, ScrollController> _scrollControllers = {};

  bool _isDragging = false;

  @override
  void initState() {
    if (_firewallController.tableHandle.value == null) WidgetsBinding.instance.addPostFrameCallback((_) => Get.offAllNamed(Routes.firewallTables.routeName));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContent(
      controllers: [
        OutlinedButton(onPressed: () => displayFirewallRuleFilterModal(false), child: Icon(Icons.add, size: 16, color: Colors.black)),
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
              itemCount: _firewallController.ruleList.length,
              itemBuilder: (context, index) {
                _scrollControllers[index] = ScrollController();
                var rule = _firewallController.ruleList[index];
                return Padding(
                  key: ValueKey(rule),
                  padding: const EdgeInsets.all(4.0),
                  child: Listener(
                    onPointerDown: (_) => setState(() => _isDragging = true),
                    onPointerUp: (_) => setState(() => _isDragging = false),
                    child: ReorderableDragStartListener(
                      index: index,
                      child: MouseRegion(
                        onHover: _isDragging ? null : (e) => startAnimate(index),
                        onExit: _isDragging ? null : (e) => revertAnimate(index),
                        child: TileItem(
                          onClick: () => print('Hello'),
                          actions: SizedBox(
                            width: 100,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () => deleteRule(rule),
                                  splashRadius: 12,
                                  icon: Icon(MdiIcons.trashCanOutline, size: 16, color: Colors.black),
                                ),
                                IconButton(
                                  onPressed: () => {},
                                  splashRadius: 12,
                                  icon: Icon(MdiIcons.pencil, size: 16, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          index: index,
                          title: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _scrollControllers[index],
                            child: Row(
                              spacing: 8,
                              children: rule.expressionWidgets(),
                            ),
                          ),
                          subTitle: rule.comment != null ? Text(rule.comment!, style: TextStyle(color: Colors.black87)) : null,
                        ),
                      ),
                    ),
                  ),
                );
              },
              onReorder: (int oldIndex, int newIndex) => updateOrder(oldIndex, newIndex),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> revertAnimate(int index) => _scrollControllers[index]!.animateTo(_scrollControllers[index]!.position.minScrollExtent, duration: Duration(seconds: 1), curve: Curves.easeInOut);

  Future<void> startAnimate(int index) => _scrollControllers[index]!.animateTo(_scrollControllers[index]!.position.maxScrollExtent, duration: Duration(seconds: 1), curve: Curves.easeInOut);

  void deleteRule(FirewallRule rule) {
    _firewallController.selectedRule.value = rule;
    _firewallController.ruleDelete();
  }

  void updateOrder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) newIndex--;
      var rule = _firewallController.ruleList.removeAt(oldIndex);
      _firewallController.ruleList.insert(newIndex, rule);
      _firewallController.ruleSwitch();
    });
  }
}
