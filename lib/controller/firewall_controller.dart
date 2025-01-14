import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/model/firewall/table.dart';
import 'package:jos_ui/service/rest_client.dart';
import 'package:jos_ui/widget/toast.dart';

class FirewallController extends GetxController {
  final TextEditingController tableNameEditingController = TextEditingController();

  var firewallTables = <FirewallTable>[].obs;
  var tableType = FirewallTableType.inet.obs;

  Future<void> tableFetch() async {
    var payload = await RestClient.rpc(Rpc.RPC_FIREWALL_TABLE_LIST);
    if (payload.metadata!.success) {
      var result = jsonDecode(payload.content!) as List;
      firewallTables.value = result.map((item) => FirewallTable.fromJson(item)).toList();
    } else {
      displayError('Failed to fetch firewall tables');
    }
  }

  Future<void> tableAdd() async {
    var reqParam = {
      'name': tableNameEditingController.text,
      'type': tableType.value.name,
    };
    var payload = await RestClient.rpc(Rpc.RPC_FIREWALL_TABLE_ADD, parameters: reqParam);
    if (payload.metadata!.success) {
      await tableFetch();
      Get.back();
      clear();
    } else {
      displayWarning('Failed to add table');
    }
  }

  Future<void> tableDelete(int id) async {
    var reqParam = {'id': id};
    var payload = await RestClient.rpc(Rpc.RPC_FIREWALL_TABLE_REMOVE, parameters: reqParam);
    if (payload.metadata!.success) {
      await tableFetch();
    } else {
      displayWarning('Failed to remove table');
    }
  }

  void clear() {
    tableNameEditingController.clear();
    tableType.value = FirewallTableType.inet;
  }
}
