import 'dart:async';
import 'dart:developer' as developer;

import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/service/storage_service.dart';
import 'package:web_socket_client/web_socket_client.dart';
import 'package:xterm/xterm.dart';

class ContainerLogWebsocketService extends GetxController {
  WebSocket? _socket;
  StreamSubscription? _subscription;
  var isConnected = false.obs;
  var isMaximize = false.obs;
  final terminalController = TerminalController();
  final terminal = Terminal(maxLines: 5000, platform: TerminalTargetPlatform.web, reflowEnabled: true);

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

  Future<void> consumeEvents(String containerName) async {
    var token = StorageService.getItem('token');
    var url = Uri.parse('${baseContainerLogWebSocketUrl()}/$token');
    _socket = WebSocket(url);
    await _socket!.connection.firstWhere((state) => state is Connected);
    isConnected.value = true;
    _socket!.send(containerName);
    _subscription = _socket!.messages.listen((e) => writeToTerminal(e), onError: (e) => developer.log('Receive error $e'), onDone: () => developer.log('websocket closed'), cancelOnError: true);
  }

  void writeToTerminal(String event) async {
    if (isConnected.value) terminal.write('$event\r\n');
  }

  void disconnectWebsocket() async {
    if (_socket != null) {
      developer.log('Container log websocket disconnected');
      await _subscription!.cancel();
      _socket!.close(1000, 'CLOSE_NORMAL');
      isConnected.value = false;
    }
  }

  void terminalReset() {
    terminalController.clearSelection();
    terminal.buffer.clear();
    terminal.altBuffer.clear();
    terminal.mainBuffer.clear();
    terminal.eraseDisplay();
    terminal.restoreCursor();
  }
}
