import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/component/tile.dart';
import 'package:jos_ui/controller/event_controller.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/service/websocket/kernel_log_websocket_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:xterm/ui.dart';

class KernelLogPage extends StatefulWidget {
  const KernelLogPage({super.key});

  @override
  State<KernelLogPage> createState() => KernelLogPageState();
}

class KernelLogPageState extends State<KernelLogPage> {
  final _kernelLogWebSocketService = Get.put(KernelLogWebsocketService());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _kernelLogWebSocketService.consumeEvents());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContent(
      child: Expanded(
        child: TerminalView(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          _kernelLogWebSocketService.terminal,
          controller: _kernelLogWebSocketService.terminalController,
          autofocus: true,
          textStyle: TerminalStyle(fontSize: 11, fontFamily: 'IBMPlexMono'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _kernelLogWebSocketService.disconnectWebsocket();
    super.dispose();
  }
}
