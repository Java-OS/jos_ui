import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/network_controller.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/model/firewall/chain.dart';
import 'package:jos_ui/model/firewall/expression/ip_expression.dart';
import 'package:jos_ui/model/firewall/expression/meta_expression.dart';
import 'package:jos_ui/model/firewall/expression/tcp_expression.dart';
import 'package:jos_ui/model/firewall/expression/udp_expression.dart';
import 'package:jos_ui/model/firewall/protocol.dart';
import 'package:jos_ui/model/firewall/rule.dart';
import 'package:jos_ui/model/firewall/statement/log_statement.dart';
import 'package:jos_ui/model/firewall/statement/nat_statement.dart';
import 'package:jos_ui/model/firewall/statement/reject_statement.dart';
import 'package:jos_ui/model/firewall/statement/verdict_statement.dart';
import 'package:jos_ui/model/firewall/table.dart';
import 'package:jos_ui/model/network/ethernet.dart';
import 'package:jos_ui/service/api_service.dart';
import 'package:jos_ui/validation/validator.dart';

class FirewallController extends GetxController with Validator {
  final _apiService = Get.put(ApiService());
  final _networkController = Get.put(NetworkController());

  var tableNameEditingController = TextEditingController();
  var chainNameEditingController = TextEditingController();

  /* table parameters */
  var tableList = <FirewallTable>[].obs;
  var chainList = <FirewallChain>[].obs;
  var ruleList = <FirewallRule>[].obs;
  var tableHandle = Rxn<int>();
  var chainHandle = Rxn<int>();
  var selectedChain = Rxn<FirewallChain>();
  var selectedRule = Rxn<FirewallRule>();

  /* chain parameters */
  var tableType = FirewallTableType.inet.obs;
  var chainType = Rxn<ChainType>();
  var chainHook = Rxn<ChainHook>();
  var chainPolicy = Rxn<ChainPolicy>();
  var chainPriority = Rxn<int>();

  /* Rule config */
  var srcAddressEditingController = TextEditingController();
  var isNotSrcAddr = false.obs;
  var dstAddressEditingController = TextEditingController();
  var isNotDstAddr = false.obs;
  var protocol = Rxn<Protocol>();
  var srcPortEditingController = TextEditingController();
  var isNotSrcPort = false.obs;
  var dstPortEditingController = TextEditingController();
  var isNotDstPort = false.obs;
  var srcInterface = Rxn<Ethernet>();
  var dstInterface = Rxn<Ethernet>();
  var natType = Rxn<NatType>();
  var natToAddressEditingController = TextEditingController();
  var natToPortEditingController = TextEditingController();
  var verdictType = Rxn<VerdictType>();
  var rejectReason = Rxn<Reason>();
  var targetChain = Rxn<FirewallChain>();
  var logLevel = Rxn<LogLevel>();

  var logPrefixEditingController = TextEditingController();
  var commentEditingController = TextEditingController();

  @override
  void onInit() {
    _networkController.fetchEthernets();
    super.onInit();
  }

  /* -------------- Table Methods -------------- */
  Future<void> tableFetch() async {
    _apiService.callApi(Rpc.RPC_FIREWALL_TABLE_LIST, message: 'Failed to fetch firewall tables').then((e) => e as List).then((list) => tableList.value = list.map((item) => FirewallTable.fromMap(item)).toList());
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
    _apiService.callApi(Rpc.RPC_FIREWALL_CHAIN_LIST, parameters: reqParam, message: 'Failed to fetch firewall chains').then((e) => e as List).then((e) => chainList.value = e.map((item) => FirewallChain.fromMap(item, tableHandle.value!)).toList());
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
      'chainIds': chainList.map((e) => e.handle).toList(),
    };
    _apiService.callApi(Rpc.RPC_FIREWALL_CHAIN_SWITCH, parameters: reqParam, message: 'Failed to switch chain').then((e) => e as List).then((e) => chainList.value = e.map((item) => FirewallChain.fromMap(item, tableHandle.value!)).toList());
  }

  /* -------------- Rule Methods -------------- */
  Future<void> ruleFetch(FirewallChain chain) async {
    selectedChain.value = chain;
    var reqParam = {
      'tableId': chain.table.handle,
      'chainId': chain.handle,
    };

    await _apiService.callApi(Rpc.RPC_FIREWALL_RULE_LIST, parameters: reqParam, message: 'Failed to fetch rules').then((e) => e as List).then((e) => ruleList.value = e.map((item) => FirewallRule.fromMap(item, chain)).toList());
  }

  Future<void> ruleAdd() async {
    if (!formKey.currentState!.validate()) return;

    // Expressions
    var srcIpExpression = srcAddressEditingController.text.isNotEmpty ? IpExpression(IpField.saddr, isNotSrcAddr.isTrue ? Operation.ne : Operation.eq, srcAddressEditingController.text) : null;
    var dstIpExpression = dstAddressEditingController.text.isNotEmpty ? IpExpression(IpField.daddr, isNotSrcAddr.isTrue ? Operation.ne : Operation.eq, dstAddressEditingController.text) : null;
    var protocolExpression = protocol.value != null ? IpExpression(IpField.protocol, Operation.eq, protocol.value!.name) : null;
    var srcPortExpression = srcPortEditingController.text.isNotEmpty
        ? protocol.value == Protocol.tcp
            ? TcpExpression(TcpField.sport, isNotSrcPort.isTrue ? Operation.ne : Operation.eq, srcPortEditingController.text)
            : UdpExpression(UdpField.sport, isNotSrcPort.isTrue ? Operation.ne : Operation.eq, srcPortEditingController.text)
        : null;
    var dstPortExpression = dstPortEditingController.text.isNotEmpty
        ? protocol.value == Protocol.tcp
            ? TcpExpression(TcpField.dport, isNotDstPort.isTrue ? Operation.ne : Operation.eq, dstPortEditingController.text)
            : UdpExpression(UdpField.dport, isNotDstPort.isTrue ? Operation.ne : Operation.eq, dstPortEditingController.text)
        : null;
    var srcInterfaceExpression = srcInterface.value != null ? MetaExpression(MetaField.iifname, Operation.eq, srcInterface.value!.iface) : null;
    var dstInterfaceExpression = dstInterface.value != null ? MetaExpression(MetaField.oifname, Operation.eq, dstInterface.value!.iface) : null;

    // Filter Statements
    var verdictStatement = (verdictType.value != null && verdictType.value != VerdictType.reject) ? VerdictStatement(verdictType.value!, targetChain.value?.name) : null;
    var rejectStatement = rejectReason.value != null ? RejectStatement(rejectReason.value) : null;
    var logStatement = logLevel.value != null ? LogStatement(logLevel.value, logPrefixEditingController.text) : null;

    // Nat Statements
    var natStatement = natType.value != null ? NatStatement([], natType.value!, natToAddressEditingController.text.isNotEmpty ? natToAddressEditingController.text : null, natToPortEditingController.text.isNotEmpty ? int.parse(natToPortEditingController.text) : null) : null;

    var list = [];

    if (srcIpExpression != null) list.add(srcIpExpression.toMap());
    if (dstIpExpression != null) list.add(dstIpExpression.toMap());
    if (protocolExpression != null) list.add(protocolExpression.toMap());
    if (srcPortExpression != null) list.add(srcPortExpression.toMap());
    if (dstPortExpression != null) list.add(dstPortExpression.toMap());
    if (srcInterfaceExpression != null) list.add(srcInterfaceExpression.toMap());
    if (dstInterfaceExpression != null) list.add(dstInterfaceExpression.toMap());
    if (logStatement != null) list.add(logStatement.toMap());
    if (verdictStatement != null) list.add(verdictStatement.toMap());
    if (rejectStatement != null) list.add(rejectStatement.toMap());
    if (natStatement != null) list.add(natStatement.toMap());

    var reqParam = {
      'rule': {
        'family': selectedChain.value!.table.type.value,
        'table': selectedChain.value!.table.name,
        'chain': selectedChain.value!.name,
        'comment': commentEditingController.text,
        'expr': list,
      }
    };
    _apiService.callApi(Rpc.RPC_FIREWALL_RULE_ADD, parameters: reqParam, message: 'Failed to add rule').then((_) => ruleFetch(selectedChain.value!)).then((_) => Get.back()).then((_) => clear());
  }

  Future<void> ruleDelete() async {
    var reqParam = selectedRule.value!.toMap();
    _apiService.callApi(Rpc.RPC_FIREWALL_RULE_REMOVE, parameters: reqParam, message: 'Failed to remove rule').then((e) => ruleFetch(selectedChain.value!));
  }

  Future<void> ruleSwitch() async {
    var reqParam = {
      'tableId': selectedChain.value!.table.handle,
      'chainId': selectedChain.value!.handle,
      'ruleIds': ruleList.map((e) => e.handle).toList(),
    };
    _apiService.callApi(Rpc.RPC_FIREWALL_RULE_SWITCH, parameters: reqParam, message: 'Failed to switch rule').then((e) => e as List).then((e) => ruleList.value = e.map((item) => FirewallRule.fromMap(item, selectedChain.value!)).toList());
  }

  void clear() {
    developer.log('clear parameters');
    tableNameEditingController.clear();
    chainNameEditingController.clear();

    // Rule parameters
    srcAddressEditingController.clear();
    dstAddressEditingController.clear();
    srcPortEditingController.clear();
    dstPortEditingController.clear();
    commentEditingController.clear();
    logPrefixEditingController.clear();
    natToAddressEditingController.clear();
    natToPortEditingController.clear();

    natType.value = null;
    protocol.value = null;
    srcInterface.value = null;
    dstInterface.value = null;
    verdictType.value = null;
    targetChain.value = null;
    logLevel.value = null;
    rejectReason.value = null;

    /* chain parameters */
    tableType = FirewallTableType.inet.obs;
    chainType = Rxn<ChainType>();
    chainHook = Rxn<ChainHook>();
    chainPolicy = Rxn<ChainPolicy>();
  }
}
