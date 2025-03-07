import 'dart:async';
import 'dart:developer' as developer;

import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/event_controller.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/service/storage_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class EventWebsocketService extends GetxController {
  final _eventController = Get.put(EventController());
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;

  @override
  void onClose() {
    disconnectWebsocket();
    super.onClose();
  }

  @override
  void dispose() {
    disconnectWebsocket();
    super.dispose();
  }

  Future<void> consumeEvents() async {
    var token = StorageService.getItem('token');
    var url = Uri.parse('${baseEventWebSocketUrl()}/$token');
    _channel = WebSocketChannel.connect(url);
    await _channel!.ready;
    _subscription = _channel!.stream.where((event) => event.isNotEmpty).map((e) => Event(e)).listen((event) => _handleEvent(event));
  }

  void _handleEvent(Event event) {
    _eventController.eventAdd(event);
  }

  void disconnectWebsocket() async {
    if (_channel != null) {
      developer.log('Event websocket disconnected');
      await _subscription!.cancel();
      await _channel!.sink.close(1001,'disconnect connection');
    }
  }
}
