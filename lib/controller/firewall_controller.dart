import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/model/firewall/chain.dart';
import 'package:jos_ui/model/firewall/table.dart';
import 'package:jos_ui/service/api_service.dart';

class FirewallController extends GetxController {
  final _apiService = Get.put(ApiService());
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
    _apiService.callApi(Rpc.RPC_FIREWALL_TABLE_LIST, message: 'Failed to fetch firewall tables').then((e) => e as List).then((list) => tableList.value = list.map((item) => FirewallTable.fromJson(item)).toList());
  }

  Future<void> tableAdd() async {
    var reqParam = {
      'name': tableNameEditingController.text,
      'type': tableType.value.value,
    };
    _apiService.callApi(Rpc.RPC_FIREWALL_TABLE_ADD, parameters: reqParam, message: 'Failed to add table').then((e) => tableFetch()).then((e) => Get.back()).then((e) => clear());
  }

  Future<void> tableDelete(int id) async {
    var reqParam = {'id': id};
    _apiService.callApi(Rpc.RPC_FIREWALL_TABLE_REMOVE, parameters: reqParam, message: 'Failed to remove table').then((e) => tableFetch());
  }

  Future<void> tableRename() async {
    var reqParam = {'id': tableHandle.value, 'name': tableNameEditingController.text};
    _apiService.callApi(Rpc.RPC_FIREWALL_TABLE_RENAME, parameters: reqParam, message: 'Failed to remove table').then((e) => tableFetch()).then((e) => Get.back()).then((e) => clear());
  }

  /* -------------- Chain Methods -------------- */
  Future<void> chainFetch() async {
    var reqParam = {
      'tableHandle': tableHandle.value,
    };
    _apiService
        .callApi(Rpc.RPC_FIREWALL_CHAIN_LIST, parameters: reqParam, message: 'Failed to fetch firewall chains')
        .then((e) => e as List)
        .then((e) => chainList.value = e.map((item) => FirewallChain.fromJson(item, tableHandle.value!)).toList());
  }

  Future<void> chainAdd() async {
    var reqParam = {
      'tableId': tableHandle.value,
      'name': chainNameEditingController.text,
      'type': chainType.value?.name,
      'hook': chainHook.value?.name,
      'policy': chainPolicy.value?.name,
    };
    _apiService.callApi(Rpc.RPC_FIREWALL_CHAIN_ADD, parameters: reqParam, message: 'Failed to add chain').then((e) => chainFetch()).then((e) => Get.back()).then((e) => clear());
  }

  Future<void> chainDelete(int tableHandle, int chainHandle) async {
    var reqParam = {
      'tableId': tableHandle,
      'chainId': chainHandle,
    };
    _apiService.callApi(Rpc.RPC_FIREWALL_CHAIN_REMOVE, parameters: reqParam, message: 'Failed to remove chain').then((e) => chainFetch());
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

    _apiService.callApi(Rpc.RPC_FIREWALL_CHAIN_UPDATE, parameters: reqParam, message: 'Failed to update chain').then((e) => chainFetch()).then((e) => Get.back()).then((e) => clear());
  }

  Future<void> chainSwitch() async {
    var reqParam = {
      'tableId': tableHandle.value,
      'chainIds': chainList.map((item) => item.handle).toList(),
    };

    _apiService.callApi(Rpc.RPC_FIREWALL_CHAIN_SWITCH, parameters: reqParam, message: 'Failed to switch chain').then((e) => chainFetch()).then((e) => clear());
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
