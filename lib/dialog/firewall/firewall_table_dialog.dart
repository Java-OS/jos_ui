import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/text_field_box.dart';
import 'package:jos_ui/controller/firewall_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';

FirewallController _firewallController = Get.put(FirewallController());

Future<void> displayFirewallTableModal(bool isRename) async {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Table'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldBox(controller: _firewallController.tableNameEditingController, label: 'Name'),
              /*SizedBox(height: 10),
              Obx(
                () => DropDownMenu<FirewallTableType>(
                  disabled: isRename,
                  displayClearButton: false,
                  requiredValue: true,
                  value: _firewallController.tableType.value,
                  label: 'Table Type (default inet)',
                  items: FirewallTableType.values.map((e) => DropdownMenuItem<FirewallTableType>(value: e, child: Text(e.name))).toList(),
                  onChanged: (value) => _firewallController.tableType.value = value,
                ),
              ),*/
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => isRename ? _firewallController.tableRename() : _firewallController.tableAdd(),
                  child: Text(isRename ? 'Rename' : 'Add'),
                ),
              ),
            ],
          )
        ],
      );
    },
  ).then((e) => _firewallController.clear());
}
