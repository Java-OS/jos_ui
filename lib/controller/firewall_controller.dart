import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/model/firewall/chain.dart';
import 'package:jos_ui/model/firewall/table.dart';
import 'package:jos_ui/service/rest_client.dart';
import 'package:jos_ui/widget/toast.dart';

class FirewallController extends GetxController {
  final TextEditingController tableNameEditingController = TextEditingController();
  final TextEditingController chainNameEditingController = TextEditingController();

  /* table parameters */
  var tableList = <FirewallTable>[].obs;
  var chainList = <FirewallChain>[].obs;
  var tableHandle = Rxn<int>();
  var chainHandle = Rxn<int>();

  /* chain parameters */
  var tableType = FirewallTableType.inet.obs;
  var chainType = Rxn<ChainType>();
  var chainHook = Rxn<ChainHook>();
  var chainPolicy = Rxn<ChainPolicy>();
  var chainPriority = Rxn<int>();

  /* -------------- Table Methods -------------- */
  Future<void> tableFetch() async {
    var payload = await RestClient.rpc(Rpc.RPC_FIREWALL_TABLE_LIST);
    if (payload.metadata!.success) {
      var result = jsonDecode(payload.content!) as List;
      tableList.value = result.map((item) => FirewallTable.fromJson(item)).toList();
    } else {
      displayError('Failed to fetch firewall tables');
    }
  }

  Future<void> tableAdd() async {
    var reqParam = {
      'name': tableNameEditingController.text,
      'type': tableType.value.value,
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

  Future<void> tableRename() async {
    var reqParam = {'id': tableHandle.value, 'name': tableNameEditingController.text};
    var payload = await RestClient.rpc(Rpc.RPC_FIREWALL_TABLE_RENAME, parameters: reqParam);
    if (payload.metadata!.success) {
      await tableFetch();
      Get.back();
      clear();
    } else {
      displayWarning('Failed to remove table');
    }
  }

  /* -------------- Chain Methods -------------- */
  Future<void> chainFetch() async {
    var reqParam = {
      'tableHandle': tableHandle.value,
    };
    var payload = await RestClient.rpc(Rpc.RPC_FIREWALL_CHAIN_LIST, parameters: reqParam);
    if (payload.metadata!.success) {
      var result = jsonDecode(payload.content!) as List;
      chainList.value = result.map((item) => FirewallChain.fromJson(item, tableHandle.value!)).toList();
    } else {
      displayError('Failed to fetch firewall chains');
    }
  }

  Future<void> chainAdd() async {
    var reqParam = {
      'tableId': tableHandle.value,
      'name': chainNameEditingController.text,
      'type': chainType.value?.name,
      'hook': chainHook.value?.name,
      'policy': chainPolicy.value?.name,
    };
    var payload = await RestClient.rpc(Rpc.RPC_FIREWALL_CHAIN_ADD, parameters: reqParam);
    if (payload.metadata!.success) {
      await chainFetch();
      Get.back();
      clear();
    } else {
      displayWarning('Failed to add chain');
    }
  }

  Future<void> chainDelete(int tableHandle, int chainHandle) async {
    var reqParam = {
      'tableId': tableHandle,
      'chainId': chainHandle,
    };
    var payload = await RestClient.rpc(Rpc.RPC_FIREWALL_CHAIN_REMOVE, parameters: reqParam);
    if (payload.metadata!.success) {
      await chainFetch();
    } else {
      displayWarning('Failed to remove table');
    }
  }

  Future<void> chainUpdate() async {
    var reqParam = {
      'tableId': tableHandle.value,
      'chainId': chainHandle.value,
      'name': chainNameEditingController.text,
      'type': chainType.value?.name,
      'hook': chainHook.value?.name,
      'policy': chainPolicy.value?.name,
      'priority': chainPriority.value,
    };

    var payload = await RestClient.rpc(Rpc.RPC_FIREWALL_CHAIN_UPDATE, parameters: reqParam);
    if (payload.metadata!.success) {
      await chainFetch();
      Get.back();
      clear();
    } else {
      displayWarning('Failed to remove table');
    }
  }

  void clear() {
    developer.log('clear parameters');
    tableNameEditingController.clear();
    chainNameEditingController.clear();

    /* chain parameters */
    tableType = FirewallTableType.inet.obs;
    chainType = Rxn<ChainType>();
    chainHook = Rxn<ChainHook>();
    chainPolicy = Rxn<ChainPolicy>();
  }
}
