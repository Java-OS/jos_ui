import 'dart:async';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/service/storage_service.dart';
import 'package:web_socket_client/web_socket_client.dart';
import 'package:xterm/xterm.dart';

class TerminalWebsocketService extends GetxController {
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

  Future<void> connect(String? execId) async {
    var token = StorageService.getItem('token');
    var url = execId == null ? Uri.parse('${baseSystemTerminalWebSocketUrl()}/$token') : Uri.parse('${baseContainerExecWebSocketUrl()}/$execId/$token');
    _socket = WebSocket(url);
    await _socket!.connection.firstWhere((state) => state is Connected);
    isConnected.value = true;
    _subscription = _socket!.messages.listen(
      (e) => writeToTerminal(e),
      onError: (e) => developer.log('Receive error $e'),
      onDone: () => developer.log('websocket closed'),
      cancelOnError: true,
    );
  }

  void writeToTerminal(String char) async {
    if (isConnected.value) terminal.write(String.fromCharCode((int.parse(char))));
  }

  void sendAscii(Uint8List array) {
    _socket!.send(array);
  }

  void disconnectWebsocket() async {
    if (_socket != null) {
      developer.log('Container terminal websocket disconnected');
      await _subscription!.cancel();
      _socket!.close(1000, 'CLOSE_NORMAL');
      isConnected.value = false;
    }
  }

  void handleKeyboardEvents(KeyEvent event) {
    int keyCode = event.logicalKey.keyId;
    final isControlPressed = HardwareKeyboard.instance.isControlPressed;
    final isAltPressed = HardwareKeyboard.instance.isAltPressed;

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      sendAscii(Uint8List.fromList([27]));
    } else if (event.logicalKey == LogicalKeyboardKey.enter) {
      sendAscii(Uint8List.fromList([10]));
    } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
      sendAscii(Uint8List.fromList([8]));
    } else if (event.logicalKey == LogicalKeyboardKey.tab) {
      sendAscii(Uint8List.fromList([9]));
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      sendAscii(Uint8List.fromList([27, 91, 65]));
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      sendAscii(Uint8List.fromList([27, 91, 66]));
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      sendAscii(Uint8List.fromList([27, 91, 67]));
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      sendAscii(Uint8List.fromList([27, 91, 68]));
    }

    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (keyCode >= 32 && keyCode <= 126) {
        sendAscii(Uint8List.fromList([event.character!.codeUnitAt(0)]));
      }
    } else {
      if (isControlPressed && event.logicalKey == LogicalKeyboardKey.digit2) {
        sendAscii(Uint8List.fromList([1]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyA) {
        sendAscii(Uint8List.fromList([1]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyB) {
        sendAscii(Uint8List.fromList([2]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyC) {
        sendAscii(Uint8List.fromList([3]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyD) {
        sendAscii(Uint8List.fromList([4]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyE) {
        sendAscii(Uint8List.fromList([5]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyF) {
        sendAscii(Uint8List.fromList([6]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyG) {
        sendAscii(Uint8List.fromList([7]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyH) {
        sendAscii(Uint8List.fromList([8]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyI) {
        sendAscii(Uint8List.fromList([9]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyJ) {
        sendAscii(Uint8List.fromList([10]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyK) {
        sendAscii(Uint8List.fromList([11]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyL) {
        sendAscii(Uint8List.fromList([12]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyM) {
        sendAscii(Uint8List.fromList([13]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyN) {
        sendAscii(Uint8List.fromList([14]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyO) {
        sendAscii(Uint8List.fromList([15]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyP) {
        sendAscii(Uint8List.fromList([16]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyQ) {
        sendAscii(Uint8List.fromList([17]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyR) {
        sendAscii(Uint8List.fromList([18]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyS) {
        sendAscii(Uint8List.fromList([19]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyT) {
        sendAscii(Uint8List.fromList([20]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyU) {
        sendAscii(Uint8List.fromList([21]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyV) {
        sendAscii(Uint8List.fromList([22]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyW) {
        sendAscii(Uint8List.fromList([23]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyX) {
        sendAscii(Uint8List.fromList([24]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyY) {
        sendAscii(Uint8List.fromList([25]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyZ) {
        sendAscii(Uint8List.fromList([26]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.bracketLeft) {
        sendAscii(Uint8List.fromList([27]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.backslash) {
        sendAscii(Uint8List.fromList([28]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.bracketRight) {
        sendAscii(Uint8List.fromList([29]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.caret) {
        sendAscii(Uint8List.fromList([30]));
      } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.underscore) {
        sendAscii(Uint8List.fromList([31]));
      } else if (isAltPressed && event.logicalKey == LogicalKeyboardKey.backspace) {
        sendAscii(Uint8List.fromList([27, 127]));
      }
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
