import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/oci_controller.dart';
import 'package:jos_ui/model/container/container_info.dart';
import 'package:jos_ui/service/websocket/terminal_websocket_service.dart';
import 'package:xterm/ui.dart';

final _containerController = Get.put(OciController());
final _terminalWebSocketService = Get.put(TerminalWebsocketService());

Future<void> displayContainerTerminal(ContainerInfo container) async {
  var execId = await _containerController.createExecInstance(container.id);
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey, width: 1)),
        child: Obx(
          () => SizedBox(
            width: _terminalWebSocketService.isMaximize.value ? double.infinity : 800,
            height: _terminalWebSocketService.isMaximize.value ? double.infinity : 400,
            child: Stack(
              children: [
                KeyboardListener(
                  includeSemantics: false,
                  onKeyEvent: (event) => _terminalWebSocketService.handleKeyboardEvents(event),
                  focusNode: FocusNode(),
                  autofocus: true,
                  child: TerminalView(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    _terminalWebSocketService.terminal,
                    controller: _terminalWebSocketService.terminalController,
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
                        icon: Icon(_terminalWebSocketService.isConnected.value == true ? LineariconsFree.frame_contract : LineariconsFree.frame_expand, color: Colors.white, size: 16),
                        onPressed: () {
                          _terminalWebSocketService.isMaximize.value = !_terminalWebSocketService.isMaximize.value;
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
  ).then((value) => _terminalWebSocketService.disconnectWebsocket()).then((_) => _terminalWebSocketService.terminalReset());

  _terminalWebSocketService.connect(execId).then((_) => resizeTTY(execId));
}

void resizeTTY(String execId) async {
  await Future.delayed(Duration(seconds: 1));
  var h = _terminalWebSocketService.terminal.viewHeight;
  var w = _terminalWebSocketService.terminal.viewWidth;
  await _containerController.createResizeTTY(execId, h, w);
}
