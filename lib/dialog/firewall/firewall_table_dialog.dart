import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/firewall_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';
import 'package:jos_ui/model/firewall/table.dart';
import 'package:jos_ui/widget/text_field_box_widget.dart';

import '../../widget/drop_down_widget.dart';

FirewallController _firewallController = Get.put(FirewallController());

Future<void> displayFirewallTableModal() async {
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
              SizedBox(height: 8),
              Obx(
                () => DropDownMenu<FirewallTableType>(
                  value: _firewallController.tableType.value,
                  hint: Text('Type of table'),
                  items: FirewallTableType.values.map((e) => DropdownMenuItem<FirewallTableType>(value: e, child: Text(e.name))).toList(),
                  onChanged: (value) => _firewallController.tableType.value = value,
                ),
              ),
              SizedBox(height: 10),
              Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: () => _firewallController.tableAdd(), child: Text('Apply'))),
            ],
          )
        ],
      );
    },
  );
}
