import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/firewall_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';
import 'package:jos_ui/model/firewall/chain.dart';
import 'package:jos_ui/widget/text_field_box_widget.dart';

import '../../widget/drop_down_widget.dart';

FirewallController _firewallController = Get.put(FirewallController());

Future<void> displayFirewallChainModal(bool isUpdate) async {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Chain'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldBox(controller: _firewallController.chainNameEditingController, label: 'Name'),
              if (!isUpdate)
                Obx(
                  () => DropDownMenu<ChainType>(
                    displayClearButton: _firewallController.chainType.value != null,
                    requiredValue: _firewallController.chainType.value != null,
                    value: _firewallController.chainType.value,
                    label: 'Type',
                    items: ChainType.getChainTypes(_firewallController.tableType.value).map((e) => DropdownMenuItem<ChainType>(value: e, child: Text(e.name))).toList(),
                    onChanged: (value) {
                      discardValues();
                      _firewallController.chainType.value = value;
                    },
                    onClear: () => discardValues(),
                  ),
                ),
              if (!isUpdate)
                Obx(
                  () => DropDownMenu<ChainHook>(
                    displayClearButton: _firewallController.chainHook.value != null,
                    requiredValue: _firewallController.chainHook.value != null,
                    value: _firewallController.chainHook.value,
                    label: 'Hook',
                    items: _firewallController.chainType.value == null ? [] : ChainHook.getHooks(_firewallController.chainType.value!).map((e) => DropdownMenuItem<ChainHook>(value: e, child: Text(e.name))).toList(),
                    onChanged: (value) => _firewallController.chainHook.value = value,
                    onClear: () => discardValues(),
                  ),
                ),
              if (!isUpdate)
                Obx(
                  () => Visibility(
                    visible: _firewallController.chainType.value != ChainType.nat,
                    child: DropDownMenu<ChainPolicy>(
                      displayClearButton: _firewallController.chainPolicy.value != null,
                      requiredValue: _firewallController.chainPolicy.value != null,
                      value: _firewallController.chainPolicy.value,
                      label: 'Policy',
                      items: _firewallController.chainType.value == null ? [] : ChainPolicy.values.map((e) => DropdownMenuItem<ChainPolicy>(value: e, child: Text(e.name))).toList(),
                      onChanged: (value) => _firewallController.chainPolicy.value = value,
                      onClear: () => discardValues(),
                    ),
                  ),
                ),
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

void discardValues() {
  _firewallController.chainType.value = null;
  _firewallController.chainHook.value = null;
  _firewallController.chainPolicy.value = null;
}
