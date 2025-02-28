import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:fetch_client/fetch_client.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/event_controller.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/service/rest_client.dart';

class SSEController extends GetxController {
  final _eventController = Get.put(EventController());
  StreamSubscription<Event>? _subscription;
  FetchResponse? _fetchResponse;

  bool get isSseConnected => _subscription != null;

  @override
  void onClose() {
    disconnectSse();
    super.onClose();
  }

  @override
  void dispose() {
    disconnectSse();
    super.dispose();
  }

  Future<void> consumeEvents() async {
    if (isSseConnected) return;

    developer.log('SSE Consumer ...');
    var content = {'code': SseConnectionType.EVENT.value};
    _fetchResponse = await RestClient.sse(jsonEncode(content));

    _subscription = _fetchResponse!.stream.where((event) => event.isNotEmpty).distinct().map((e) => Event(e)).listen(
          (event) => _handleEvent(event),
          cancelOnError: true,
          onError: (error) => _handleSseError(error),
          onDone: () => _handleSseDone(),
        );
  }

  void _handleEvent(Event event) {
    _eventController.eventAdd(event);
  }

  void _handleSseError(dynamic error) {
    developer.log('SSE Error: $error');
    _subscription?.cancel();
    _subscription = null;
    consumeEvents();
  }

  void _handleSseDone() {
    developer.log('SSE connection finished');
    _subscription = null;
    consumeEvents();
  }

  void disconnectSse() {
    developer.log('SSE disconnected');
    _subscription?.cancel();
    _subscription = null;
    _fetchResponse!.cancel();
  }
}
