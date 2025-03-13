import 'dart:convert';
import 'dart:developer' as developer;

import 'package:get/get.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/service/api_service.dart';

class EventController extends GetxController {
  final _apiService = Get.put(ApiService());

  var listEvents = <Event>[].obs;

  Future<void> eventFetch() async {
    developer.log('Fetch events');
    _apiService.callApi(Rpc.RPC_EVENT_LIST, message: 'Failed to fetch events').then((e) => e as List).then((list) => listEvents.value = list.map((e) => base64Decode(e)).map((e) => Event(e)).toList());
  }

  Future<void> eventRead(String uid) async {
    developer.log('Mark event as read');
    var reqParam = {
      'uid': uid,
    };
    _apiService.callApi(Rpc.RPC_EVENT_READ, parameters: reqParam, message: 'Failed to mark event as read', disableLoading: true).then((e) => e as List).then((list) => list.map((e) => base64Decode(e)).toList()).then((list) => listEvents.value = list.map((e) => Event(e)).toList());
  }

  Future<void> eventReadAll() async {
    developer.log('Mark all events as read');
    _apiService.callApi(Rpc.RPC_EVENT_READ_ALL, message: 'Failed to mark all events as read', disableLoading: true)
        .then((e) => e as List)
        .then((list) => listEvents.value = list.map((e) => base64Decode(e)).map((e) => Event(e))
        .toList());
  }

  Future<void> eventGet(String uid) async {
    developer.log('Get event uid $uid');
    var reqParam = {
      'uid': uid,
    };

    var response = await _apiService.callApi(Rpc.RPC_EVENT_GET, parameters: reqParam, message: 'Failed to get event', disableLoading: true);
    developer.log('>>>> $response');
  }

  Future<void> eventAdd(Event event) async {
    listEvents.removeWhere((e) => e.uid == event.uid);
    listEvents.add(event);
  }

  bool hasUnreadEvent() {
    return listEvents.any((e) => !e.read);
  }
}
