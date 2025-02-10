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
import 'package:jos_ui/validation/validator.dart';
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
              () => Form(
                key: _firewallController.formKey,
                child: Column(
                  spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getSrcAddrWidget(),
                    getDstAddrWidget(),
                    getProtocolWidget(),
                    getSrcPortWidget(),
                    getDstPortWidget(),
                    if (isFilter() || (isNat() && !isOutput())) getInputInterfaceWidget(),
                    if (isFilter() || (isNat() && !isInput())) getOutputInterfaceWidget(),
                    getActionWidget(),
                    if (isFilter() || (isNat() && !isMasquerade() && (isDnat() || isSnat()))) getAddressRejectWidget(),
                    if (isFilter() || (isNat() && !isMasquerade())) getPortChainWidget(),
                    getLogLevelWidget(),
                    getLogPrefixWidget(),
                    getCommentWidget(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () => _firewallController.ruleAddOrUpdate(isUpdate),
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

Widget getCommentWidget() {
  return RuleInputText(
    label: 'Comment',
    validator: (e) => _firewallController.validateOnlyEnglishCharacters(e),
    onDeactivate: () => _firewallController.commentEditingController.clear(),
    displayCheckBox: false,
    controller: _firewallController.commentEditingController,
  );
}

Widget getLogPrefixWidget() {
  return RuleInputText(
    enable: _firewallController.logLevel.value != null,
    label: 'Log. Prefix',
    validator: (e) => _firewallController.validateOnlyEnglishCharacters(e),
    onDeactivate: () => _firewallController.logPrefixEditingController.clear(),
    displayCheckBox: false,
    controller: _firewallController.logPrefixEditingController,
  );
}

Widget getLogLevelWidget() {
  return RuleDropDown(
    active: _firewallController.logLevel.value != null,
    displayClearButton: _firewallController.logLevel.value != null,
    label: 'Log. Level',
    onClear: () {
      _firewallController.logLevel.value = null;
      _firewallController.logPrefixEditingController.clear();
    },
    onDropDownChange: (e) => _firewallController.logLevel.value = e,
    dropDownItems: logLevelItems(),
    dropDownValue: _firewallController.logLevel.value,
  );
}

Widget getPortChainWidget() {
  return Visibility(
    visible: !isNat(),
    replacement: RuleInputText(
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      enable: _firewallController.natType.value != NatType.masquerade,
      label: isSnat() ? 'From Port (0-65535)' : 'To Port (0-65535)',
      onDeactivate: () {
        if (isRedirect()) _firewallController.natType.value = null;
        _firewallController.natToPortEditingController.clear();
      },
      displayCheckBox: false,
      controller: _firewallController.natToPortEditingController,
    ),
    child: RuleDropDown(
      enable: false,
      active: chainItems().isNotEmpty && (_firewallController.verdictType.value == VerdictType.goto || _firewallController.verdictType.value == VerdictType.jump),
      displayClearButton: _firewallController.targetChain.value != null,
      label: 'Target Chain',
      onClear: () => _firewallController.targetChain.value = null,
      onDropDownChange: (e) => _firewallController.targetChain.value = e,
      dropDownItems: chainItems(),
      dropDownValue: _firewallController.targetChain.value,
    ),
  );
}

Widget getAddressRejectWidget() {
  return Visibility(
    visible: !isNat(),
    replacement: RuleInputText(
      enable: isSnat() || isDnat(),
      label: isDnat() ? 'To Address' : 'From Address',
      onDeactivate: () => _firewallController.natToAddressEditingController.clear(),
      displayCheckBox: false,
      controller: _firewallController.natToAddressEditingController,
    ),
    child: RuleDropDown(
      enable: false,
      active: _firewallController.verdictType.value == VerdictType.reject,
      displayClearButton: _firewallController.rejectReason.value != null,
      label: 'Reject with',
      onClear: () => _firewallController.rejectReason.value = null,
      onDropDownChange: (e) => _firewallController.rejectReason.value = e,
      dropDownItems: rejectReasonItems(),
      dropDownValue: _firewallController.rejectReason.value,
    ),
  );
}

Widget getActionWidget() {
  return Visibility(
    visible: !isNat(),
    replacement: RuleDropDown(
      required: true,
      displayClearButton: _firewallController.natType.value != null,
      active: true,
      label: 'Action',
      onDropDownChange: (e) => _firewallController.natType.value = e,
      dropDownItems: getNatItems(),
      dropDownValue: _firewallController.natType.value,
    ),
    child: RuleDropDown(
      required: true,
      displayClearButton: _firewallController.verdictType.value != null,
      active: true,
      label: 'Action',
      onDropDownChange: (e) {
        _firewallController.verdictType.value = e;
        _firewallController.targetChain.value = null;
      },
      dropDownItems: VerdictType.values.map((e) => DropdownMenuItem<VerdictType>(value: e, child: Text(e.value))).toList(),
      dropDownValue: _firewallController.verdictType.value,
    ),
  );
}

Widget getOutputInterfaceWidget() {
  return Visibility(
    visible: isFilter() || (isNat() && !isOutput()),
    replacement: RuleInputText(
      enable: false,
      label: _firewallController.dstInterface.value != null ? 'Out. Interface (${_firewallController.dstInterface.value!.iface})' : 'Out. Interface',
    ),
    child: RuleDropDown(
      active: _firewallController.dstInterface.value != null,
      displayClearButton: _firewallController.dstInterface.value != null,
      label: 'Out. Interface',
      onClear: () => _firewallController.dstInterface.value = null,
      onDropDownChange: (e) => _firewallController.dstInterface.value = e,
      dropDownItems: interfaceItems(),
      dropDownValue: _firewallController.dstInterface.value,
    ),
  );
}

Widget getInputInterfaceWidget() {
  return Visibility(
    visible: isFilter() || (isNat() && !isInput()),
    replacement: RuleInputText(
      enable: false,
      label: _firewallController.srcInterface.value != null ? 'In. Interface (${_firewallController.srcInterface.value!.iface})' : 'In. Interface',
    ),
    child: RuleDropDown(
      active: _firewallController.srcInterface.value != null,
      displayClearButton: _firewallController.srcInterface.value != null,
      label: 'In. Interface',
      onClear: () => _firewallController.srcInterface.value = null,
      onDropDownChange: (e) => _firewallController.srcInterface.value = e,
      dropDownItems: interfaceItems(),
      dropDownValue: _firewallController.srcInterface.value,
    ),
  );
}

Widget getDstPortWidget() {
  return RuleInputText(
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    label: 'Dst. Port (0-65535)',
    controller: _firewallController.dstPortEditingController,
    onNot: (e) => _firewallController.isNotDstPort.value = e,
    onDeactivate: () => _firewallController.dstPortEditingController.clear(),
    enable: _firewallController.protocol.value != null && _firewallController.protocol.value != Protocol.icmp,
    validator: (e) => _firewallController.validatePortNumber(e),
  );
}

Widget getSrcPortWidget() {
  return RuleInputText(
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    label: 'Src. Port (0-65535)',
    controller: _firewallController.srcPortEditingController,
    onNot: (e) => _firewallController.isNotSrcPort.value = e,
    onDeactivate: () => _firewallController.srcPortEditingController.clear(),
    enable: _firewallController.protocol.value != null && _firewallController.protocol.value != Protocol.icmp,
    validator: (e) => _firewallController.validatePortNumber(e),
  );
}

Widget getProtocolWidget() {
  return RuleDropDown<Protocol>(
    active: _firewallController.protocol.value != null,
    onClear: () {
      _firewallController.protocol.value = null;
      _firewallController.rejectReason.value = null;
      _firewallController.isNotSrcPort.value = false;
      _firewallController.isNotDstPort.value = false;
      _firewallController.srcPortEditingController.clear();
      _firewallController.dstPortEditingController.clear();
    },
    displayClearButton: _firewallController.protocol.value != null,
    label: 'Protocol',
    onDropDownChange: (e) => _firewallController.protocol.value = e,
    dropDownItems: protocolItems(),
    dropDownValue: Protocol.tcp,
  );
}

Widget getDstAddrWidget() {
  return Visibility(
    visible: isFilter() || (isNat() && (isOutput() || isPrerouting() || isPostrouting())),
    replacement: RuleDropDown(
      displayClearButton: _firewallController.dstInterface.value != null,
      label: 'Dst. Addresses',
      onClear: () => _firewallController.dstInterface.value = null,
      onDropDownChange: (e) {
        if (isNat() && isInput()) {
          _firewallController.srcInterface.value = e;
        } else {
          _firewallController.dstInterface.value = e;
        }
      },
      dropDownItems: interfaceIpItems(),
      dropDownValue: _firewallController.dstInterface.value,
    ),
    child: RuleInputText(
      label: 'Dst. Address',
      controller: _firewallController.dstAddressEditingController,
      onNot: (e) => _firewallController.isNotDstAddr.value = e,
      onDeactivate: () => _firewallController.dstAddressEditingController.clear(),
      validator: (e) => _firewallController.validateIpAddress(e),
    ),
  );
}

Widget getSrcAddrWidget() {
  return Visibility(
    visible: isFilter() || (isNat() && (isInput() || isPrerouting() || isPostrouting())),
    replacement: RuleDropDown(
      displayClearButton: _firewallController.srcInterface.value != null,
      label: 'Src. Addresses',
      onClear: () => _firewallController.srcInterface.value = null,
      onDropDownChange: (e) {
        if (isNat() && isOutput()) {
          _firewallController.dstInterface.value = e;
        } else {
          _firewallController.srcInterface.value = e;
        }
      },
      dropDownItems: interfaceIpItems(),
      dropDownValue: _firewallController.srcInterface.value,
    ),
    child: RuleInputText(
      label: 'Src. Address',
      controller: _firewallController.srcAddressEditingController,
      onNot: (e) => _firewallController.isNotSrcAddr.value = e,
      onDeactivate: () => _firewallController.srcAddressEditingController.clear(),
      validator: (e) => _firewallController.validateIpAddress(e),
    ),
  );
}

List<DropdownMenuItem<NatType>> getNatItems() {
  var hook = _firewallController.chainHook.value;
  if (hook == ChainHook.prerouting || hook == ChainHook.output) {
    return NatType.values.where((e) => e == NatType.dnat || e == NatType.redirect).map((e) => DropdownMenuItem<NatType>(value: e, child: Text(e.name))).toList();
  } else if (hook == ChainHook.postrouting) {
    return NatType.values.where((e) => e == NatType.snat || e == NatType.masquerade).map((e) => DropdownMenuItem<NatType>(value: e, child: Text(e.name))).toList();
  } else {
    return NatType.values.where((e) => e == NatType.snat).map((e) => DropdownMenuItem<NatType>(value: e, child: Text(e.name))).toList();
  }
}

List<DropdownMenuItem<dynamic>> interfaceItems() {
  return _networkController.ethernetList.map((e) => DropdownMenuItem<Ethernet>(value: e, child: Text(e.iface))).toList();
}

List<DropdownMenuItem<dynamic>> interfaceIpItems() {
  return _networkController.ethernetList.where((e) => e.ip != null).map((e) => DropdownMenuItem<Ethernet>(value: e, child: Text(e.ip!))).toList();
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

bool isPrerouting() => _firewallController.chainHook.value != null && _firewallController.chainHook.value == ChainHook.prerouting;

bool isPostrouting() => _firewallController.chainHook.value != null && _firewallController.chainHook.value == ChainHook.postrouting;

bool isInput() => _firewallController.chainHook.value != null && _firewallController.chainHook.value == ChainHook.input;

bool isOutput() => _firewallController.chainHook.value != null && _firewallController.chainHook.value == ChainHook.output;

bool isNat() => _firewallController.chainType.value != null && _firewallController.chainType.value == ChainType.nat;

bool isFilter() => _firewallController.chainType.value != null && _firewallController.chainType.value == ChainType.filter;

bool isDnat() => _firewallController.natType.value == NatType.dnat;

bool isSnat() => _firewallController.natType.value == NatType.snat;

bool isMasquerade() => _firewallController.natType.value == NatType.masquerade;

bool isRedirect() => _firewallController.natType.value == NatType.redirect;