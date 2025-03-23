import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/component/key_value.dart';
import 'package:jos_ui/component/tile.dart';
import 'package:jos_ui/controller/log_controller.dart';
import 'package:jos_ui/dialog/log_dialog.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ModuleLogPage extends StatefulWidget {
  const ModuleLogPage({super.key});

  @override
  State<ModuleLogPage> createState() => _ModuleLogPageState();
}

class _ModuleLogPageState extends State<ModuleLogPage> {
  final _logController = Get.put(LogController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((e) => _logController.fetchAppenders());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContent(
      controllers: [
      ],
      child: Obx(
        () => ListView.builder(
          shrinkWrap: true,
          itemCount: _logController.logAppenders.length,
          itemBuilder: (BuildContext buildContext, int index) {
            var logInfo = _logController.logAppenders[index];
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: TileItem(
                actions: SizedBox(
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Visibility(visible: logInfo.type != 'SYSLOG', child: IconButton(onPressed: () => displayLiveLoggerModal(logInfo), icon: Icon(Icons.receipt_long_rounded, size: 16, color: Colors.black), splashRadius: 12)),
                      IconButton(onPressed: () => logInfo.type == 'SYSLOG' ? displaySysLogAppender(logInfo) : displayFileLogAppender(logInfo), icon: Icon(Icons.edit, size: 16, color: Colors.black), splashRadius: 12),
                      IconButton(onPressed: () => _logController.removeAppender(logInfo.id), icon: Icon(MdiIcons.trashCanOutline, size: 16, color: Colors.black), splashRadius: 12),
                    ],
                  ),
                ),
                index: index,
                leading: SvgPicture.asset(
                  logInfo.type == 'SYSLOG' ? 'assets/svg/syslog.svg' : 'assets/svg/jvm-log.svg',
                  width: 50,
                ),
                title: Text(logInfo.packageName),
                subTitle: Row(
                  spacing: 8,
                  children: [
                    KeyValue(k: 'Level', v: logInfo.level),
                    KeyValue(k: 'Pattern', v: logInfo.pattern),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
