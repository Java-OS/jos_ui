import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/firewall_controller.dart';
import 'package:jos_ui/controller/network_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';
import 'package:jos_ui/model/firewall/chain.dart';
import 'package:jos_ui/model/firewall/protocol.dart';
import 'package:jos_ui/model/firewall/statement/log_statement.dart';
import 'package:jos_ui/model/firewall/statement/nat_statement.dart';
import 'package:jos_ui/model/firewall/statement/reject_statement.dart';
import 'package:jos_ui/model/firewall/statement/verdict_statement.dart';
import 'package:jos_ui/model/network/ethernet.dart';
import 'package:jos_ui/widget/rule_drop_down.dart';
import 'package:jos_ui/widget/rule_input_text.dart';

FirewallController _firewallController = Get.put(FirewallController());
NetworkController _networkController = Get.put(NetworkController());

Future<void> displayFirewallRuleFilterModal(bool isUpdate) async {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Rule'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          SizedBox(
            width: 250,
            child: Obx(
                  () =>
                  Form(
                    key: _firewallController.formKey,
                    child: Column(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RuleInputText(
                          label: 'Src. Address',
                          controller: _firewallController.srcAddressEditingController,
                          onNot: (e) => _firewallController.isNotSrcAddr.value = e,
                          onDeactivate: () => _firewallController.srcAddressEditingController.clear(),
                          validator: (e) => _firewallController.validateIpAddress(e),
                        ),
                        RuleInputText(
                          label: 'Dst. Address',
                          controller: _firewallController.dstAddressEditingController,
                          onNot: (e) => _firewallController.isNotDstAddr.value = e,
                          onDeactivate: () => _firewallController.dstAddressEditingController.clear(),
                          validator: (e) => _firewallController.validateIpAddress(e),
                        ),
                        RuleDropDown<Protocol>(
                          onClear: () {
                            _firewallController.protocol.value = null;
                            _firewallController.rejectReason.value = null;
                            _firewallController.isNotSrcPort.value = false;
                            _firewallController.isNotDstPort.value = false;
                            _firewallController.srcPortEditingController.clear();
                            _firewallController.dstPortEditingController.clear();
                          },
                          displayClearButton: true,
                          label: 'Protocol',
                          onDropDownChange: (e) => _firewallController.protocol.value = e,
                          dropDownItems: protocolItems(),
                          dropDownValue: Protocol.tcp,
                        ),
                        RuleInputText(
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          label: 'Src. Port (0-65535)',
                          controller: _firewallController.srcPortEditingController,
                          onNot: (e) => _firewallController.isNotSrcPort.value = e,
                          onDeactivate: () => _firewallController.srcPortEditingController.clear(),
                          enable: _firewallController.protocol.value != null && _firewallController.protocol.value != Protocol.icmp,
                          validator: (e) => _firewallController.validatePortNumber(e),
                        ),
                        RuleInputText(
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          label: 'Dst. Port (0-65535)',
                          controller: _firewallController.dstPortEditingController,
                          onNot: (e) => _firewallController.isNotDstPort.value = e,
                          onDeactivate: () => _firewallController.dstPortEditingController.clear(),
                          enable: _firewallController.protocol.value != null && _firewallController.protocol.value != Protocol.icmp,
                          validator: (e) => _firewallController.validatePortNumber(e),
                        ),
                        RuleDropDown(
                          displayClearButton: true,
                          label: 'In. Interface',
                          onClear: () => _firewallController.srcInterface.value = null,
                          onDropDownChange: (e) => _firewallController.srcInterface.value = e,
                          dropDownItems: interfaceItems(),
                          dropDownValue: _firewallController.srcInterface.value,
                        ),
                        RuleDropDown(
                          displayClearButton: true,
                          label: 'Out. Interface',
                          onClear: () => _firewallController.dstInterface.value = null,
                          onDropDownChange: (e) => _firewallController.dstInterface.value = e,
                          dropDownItems: interfaceItems(),
                          dropDownValue: _firewallController.dstInterface.value,
                        ),
                        Visibility(
                          visible: _firewallController.selectedChain.value!.type != ChainType.nat,
                          replacement: RuleDropDown(
                            displayClearButton: false,
                            active: true,
                            label: 'Action',
                            onDropDownChange: (e) {
                              _firewallController.natType.value = e;
                            },
                            dropDownItems: getNatItems(),
                            dropDownValue: _firewallController.natType.value,
                          ),
                          child: RuleDropDown(
                            displayClearButton: false,
                            active: true,
                            label: 'Action',
                            onDropDownChange: (e) {
                              _firewallController.verdictType.value = e;
                              _firewallController.targetChain.value = null;
                            },
                            dropDownItems: VerdictType.values.map((e) => DropdownMenuItem<VerdictType>(value: e, child: Text(e.value))).toList(),
                            dropDownValue: _firewallController.verdictType.value,
                          ),
                        ),
                        Visibility(
                          visible: _firewallController.selectedChain.value!.type != ChainType.nat,
                          replacement: RuleInputText(
                            enable: _firewallController.natType.value == NatType.snat || _firewallController.natType.value == NatType.dnat,
                            label: 'To Address',
                            onDeactivate: () => _firewallController.natToAddressEditingController.clear(),
                            displayCheckBox: false,
                            controller: _firewallController.natToAddressEditingController,
                          ),
                          child: RuleDropDown(
                            enable: false,
                            active: _firewallController.verdictType.value == VerdictType.reject,
                            displayClearButton: false,
                            label: 'Reject with',
                            onClear: () => _firewallController.rejectReason.value = null,
                            onDropDownChange: (e) => _firewallController.rejectReason.value = e,
                            dropDownItems: rejectReasonItems(),
                            dropDownValue: _firewallController.rejectReason.value,
                          ),
                        ),
                        Visibility(
                          visible: _firewallController.selectedChain.value!.type != ChainType.nat,
                          replacement: RuleInputText(
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            enable: _firewallController.natType.value != NatType.masquerade,
                            label: 'To port (0-65535)',
                            onDeactivate: () => _firewallController.natToPortEditingController.clear(),
                            displayCheckBox: false,
                            controller: _firewallController.natToPortEditingController,
                          ),
                          child: RuleDropDown(
                            enable: false,
                            active: chainItems().isNotEmpty && (_firewallController.verdictType.value == VerdictType.goto || _firewallController.verdictType.value == VerdictType.jump),
                            displayClearButton: false,
                            label: 'Target Chain',
                            onClear: () => _firewallController.targetChain.value = null,
                            onDropDownChange: (e) => _firewallController.targetChain.value = e,
                            dropDownItems: chainItems(),
                            dropDownValue: _firewallController.targetChain.value,
                          ),
                        ),
                        RuleDropDown(
                          displayClearButton: true,
                          label: 'Log. Level',
                          onClear: () {
                            _firewallController.logLevel.value = null;
                            _firewallController.logPrefixEditingController.clear();
                          },
                          onDropDownChange: (e) => _firewallController.logLevel.value = e,
                          dropDownItems: logLevelItems(),
                          dropDownValue: _firewallController.logLevel.value,
                        ),
                        RuleInputText(
                          enable: _firewallController.logLevel.value != null,
                          label: 'Log. Prefix',
                          onDeactivate: () => _firewallController.logPrefixEditingController.clear(),
                          displayCheckBox: false,
                          controller: _firewallController.logPrefixEditingController,
                        ),
                        RuleInputText(
                          label: 'Comment',
                          onDeactivate: () => _firewallController.commentEditingController.clear(),
                          displayCheckBox: false,
                          controller: _firewallController.commentEditingController,
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            // onPressed: () => isUpdate ? _firewallController.chainUpdate() : _firewallController.chainAdd(),
                            onPressed: () => _firewallController.ruleAdd(),
                            child: Text(isUpdate ? 'Update' : 'Add'),
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
          )
        ],
      );
    },
  ).then((e) => _firewallController.clear());
}

List<DropdownMenuItem<NatType>> getNatItems() {
  var hook = _firewallController.chainHook.value;
  if (hook == ChainHook.prerouting || hook == ChainHook.output) {
    return NatType.values.where((e) => e == NatType.dnat).map((e) => DropdownMenuItem<NatType>(value: e, child: Text(e.name))).toList();
  } else if ((hook == ChainHook.postrouting || hook == ChainHook.postrouting)) {
    return NatType.values.where((e) => e == NatType.snat).map((e) => DropdownMenuItem<NatType>(value: e, child: Text(e.name))).toList();
  } else {
    return NatType.values.where((e) => e == NatType.masquerade || e == NatType.redirect).map((e) => DropdownMenuItem<NatType>(value: e, child: Text(e.name))).toList();
  }
}

List<DropdownMenuItem<dynamic>> interfaceItems() {
  return _networkController.ethernetList.map((e) => DropdownMenuItem<Ethernet>(value: e, child: Text(e.iface))).toList();
}

List<DropdownMenuItem<dynamic>> chainItems() {
  return _firewallController.chainList.where((e) => e.type == null).where((e) => e.name != _firewallController.selectedChain.value!.name).map((e) => DropdownMenuItem<FirewallChain>(value: e, child: Text(e.name))).toList();
}

List<DropdownMenuItem<Protocol>> protocolItems() {
  return Protocol.values.map((e) => DropdownMenuItem<Protocol>(value: e, child: Text(e.name))).toList();
}

List<DropdownMenuItem<LogLevel>> logLevelItems() {
  return LogLevel.values.map((e) => DropdownMenuItem<LogLevel>(value: e, child: Text(e.name))).toList();
}

List<DropdownMenuItem<Reason>> rejectReasonItems() {
  var isTcp = _firewallController.protocol.value == Protocol.tcp;
  return Reason.values
      .where((e) {
    if (!isTcp) return e != Reason.tcpReset;
    return true;
  })
      .map((e) => DropdownMenuItem<Reason>(value: e, child: Text(e.value.replaceAll('-', ' '))))
      .toList();
}
