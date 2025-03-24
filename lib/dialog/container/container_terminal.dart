import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/oci_controller.dart';
import 'package:jos_ui/model/container/container_info.dart';
import 'package:jos_ui/service/websocket/container_exec_websocket_service.dart';
import 'package:xterm/ui.dart';

final _containerController = Get.put(OciController());
final _containerExecWebSocketService = Get.put(ContainerExecWebsocketService());

Future<void> displayTerminal(ContainerInfo container) async {
  var execId = await _containerController.createExecInstance(container.id);
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Obx(
          () => SizedBox(
            width: _containerExecWebSocketService.isMaximize.value ? double.infinity : 800,
            height: _containerExecWebSocketService.isMaximize.value ? double.infinity : 400,
            child: Stack(
              children: [
                KeyboardListener(
                  includeSemantics: false,
                  onKeyEvent: (event) => handleKeyboardEvents(event),
                  focusNode: FocusNode(),
                  autofocus: true,
                  child: TerminalView(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    _containerExecWebSocketService.terminal,
                    controller: _containerExecWebSocketService.terminalController,
                    autofocus: true,
                    textStyle: TerminalStyle(fontSize: 11, fontFamily: 'IBMPlexMono'),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    spacing: 4,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.clear_all, color: Colors.white, size: 16),
                        onPressed: () => _containerExecWebSocketService.terminalReset(),
                      ),
                      IconButton(
                        icon: Icon(_containerExecWebSocketService.isConnected.value == true ? LineariconsFree.frame_contract : LineariconsFree.frame_expand, color: Colors.white, size: 16),
                        onPressed: () {
                          _containerExecWebSocketService.isMaximize.value = !_containerExecWebSocketService.isMaximize.value;
                          resizeTTY(execId);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white, size: 18),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  ).then((value) => _containerExecWebSocketService.disconnectWebsocket()).then((_) => _containerExecWebSocketService.terminalReset());

  _containerExecWebSocketService.connect(execId).then((_) => resizeTTY(execId));
}

void resizeTTY(String execId) async {
  await Future.delayed(Duration(seconds: 1));
  var h = _containerExecWebSocketService.terminal.viewHeight;
  var w = _containerExecWebSocketService.terminal.viewWidth;
  await _containerController.createResizeTTY(execId, h, w);
}

void handleKeyboardEvents(KeyEvent event) {
  int keyCode = event.logicalKey.keyId;
  final isControlPressed = HardwareKeyboard.instance.isControlPressed;
  final isAltPressed = HardwareKeyboard.instance.isAltPressed;

  if (event.logicalKey == LogicalKeyboardKey.escape) {
    _containerExecWebSocketService.sendAscii(Uint8List.fromList([27]));
  } else if (event.logicalKey == LogicalKeyboardKey.enter) {
    _containerExecWebSocketService.sendAscii(Uint8List.fromList([10]));
  } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
    _containerExecWebSocketService.sendAscii(Uint8List.fromList([8]));
  } else if (event.logicalKey == LogicalKeyboardKey.tab) {
    _containerExecWebSocketService.sendAscii(Uint8List.fromList([9]));
  } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
    _containerExecWebSocketService.sendAscii(Uint8List.fromList([27, 91, 65]));
  } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
    _containerExecWebSocketService.sendAscii(Uint8List.fromList([27, 91, 66]));
  } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
    _containerExecWebSocketService.sendAscii(Uint8List.fromList([27, 91, 67]));
  } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
    _containerExecWebSocketService.sendAscii(Uint8List.fromList([27, 91, 68]));
  }

  if (event is KeyDownEvent || event is KeyRepeatEvent) {
    if (keyCode >= 32 && keyCode <= 126) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([event.character!.codeUnitAt(0)]));
    }
  } else {
    if (isControlPressed && event.logicalKey == LogicalKeyboardKey.digit2) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([1]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyA) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([1]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyB) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([2]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyC) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([3]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyD) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([4]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyE) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([5]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyF) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([6]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyG) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([7]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyH) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([8]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyI) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([9]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyJ) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([10]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyK) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([11]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyL) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([12]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyM) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([13]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyN) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([14]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyO) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([15]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyP) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([16]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyQ) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([17]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyR) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([18]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyS) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([19]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyT) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([20]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyU) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([21]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyV) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([22]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyW) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([23]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyX) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([24]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyY) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([25]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.keyZ) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([26]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.bracketLeft) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([27]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.backslash) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([28]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.bracketRight) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([29]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.caret) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([30]));
    } else if (isControlPressed && event.logicalKey == LogicalKeyboardKey.underscore) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([31]));
    } else if (isAltPressed && event.logicalKey == LogicalKeyboardKey.backspace) {
      _containerExecWebSocketService.sendAscii(Uint8List.fromList([27, 127]));
    }
  }
}