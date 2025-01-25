import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/firewall_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';
import 'package:jos_ui/model/firewall/chain.dart';
import 'package:jos_ui/model/firewall/protocol.dart';
import 'package:jos_ui/model/firewall/statement/log_statement.dart';
import 'package:jos_ui/model/firewall/statement/nat_statement.dart';
import 'package:jos_ui/model/firewall/statement/verdict_statement.dart';
import 'package:jos_ui/widget/rule_drop_down.dart';
import 'package:jos_ui/widget/rule_input_text.dart';

FirewallController _firewallController = Get.put(FirewallController());

Future<void> displayFirewallRuleFilterModal(ChainType type, bool isUpdate) async {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Rule'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RuleInputText(
                label: 'Src. Address',
              ),
              RuleInputText(
                label: 'Dst. Address',
              ),
              RuleDropDown<Protocol>(
                label: 'Protocol',
                onDropDownChange: (e) {},
                dropDownItems: protocolItems(),
                dropDownValue: Protocol.tcp,
              ),
              RuleInputText(
                label: 'Src. Port',
              ),
              RuleInputText(
                label: 'Dst. Port',
              ),
              RuleInputText(
                label: 'In. Interface',
              ),
              RuleInputText(
                label: 'Out. Interface',
              ),
              RuleDropDown(
                active: true,
                label: 'Action',
                onDropDownChange: (e) {},
                dropDownItems: actionItems(type),
                dropDownValue: null,
              ),
              RuleDropDown(
                label: 'Log. Level',
                onDropDownChange: (e) {},
                dropDownItems: logLevelItems(),
                dropDownValue: null,
              ),
              RuleInputText(label: 'Log. Prefix', displayCheckBox: false),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => isUpdate ? _firewallController.chainUpdate() : _firewallController.chainAdd(),
                  child: Text(isUpdate ? 'Update' : 'Add'),
                ),
              ),
            ],
          )
        ],
      );
    },
  ).then((e) => _firewallController.clear());
}

List<DropdownMenuItem<dynamic>> actionItems(ChainType type) {
  if (type == ChainType.nat) {
    return VerdictType.values.map((e) => DropdownMenuItem<VerdictType>(value: e, child: Text(e.value))).toList();
  } else {
    return NatType.values.map((e) => DropdownMenuItem<NatType>(value: e, child: Text(e.value))).toList();
  }
}

List<DropdownMenuItem<Protocol>> protocolItems() {
  return Protocol.values.map((e) => DropdownMenuItem<Protocol>(value: e, child: Text(e.name))).toList();
}

List<DropdownMenuItem<LogLevel>> logLevelItems() {
  return LogLevel.values.map((e) => DropdownMenuItem<LogLevel>(value: e, child: Text(e.name))).toList();
}