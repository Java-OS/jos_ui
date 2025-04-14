import 'dart:async';
import 'dart:developer' as developer;

import 'package:get/get.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/model/graph.dart';
import 'package:jos_ui/model/graph_timeframe.dart';
import 'package:jos_ui/service/api_service.dart';

class GraphController extends GetxController {
  final _apiService = Get.put(ApiService());
  Timer? _timer;
  var graphList = <Graph>[].obs;
  var timeframe = GraphTimeframe.hourly.obs;

  void startTimer(Function callback) {
    _timer = Timer.periodic(Duration(minutes: 1), (_) => callback());
  }

  Future<void> fetchGraph(double width, double height,bool disableLoading) async {
    developer.log('List graph images');
    var reqParam = {
      'timeframe': timeframe.value.name.toUpperCase(),
      'width': width,
      'height': height,
    };
    await _apiService.callApi(Rpc.RPC_RRD_GRAPH_FETCH, parameters: reqParam, disableLoading: disableLoading).then((e) => e as List).then((e) => graphList.value = e.map((item) => Graph.fromMap(item)).toList());
  }

  Future<void> sortGraph() async {
    developer.log('Sort graph');
    var reqParam = {
      'timeframe': timeframe.value.name.toUpperCase(),
      'sort': graphList.map((e) => e.name).join(','),
    };
    _apiService.callApi(Rpc.RPC_RRD_GRAPH_SORT, parameters: reqParam,disableLoading: true).then((e) => e as List).then((e) => graphList.value = e.map((item) => Graph.fromMap(item)).toList());
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
