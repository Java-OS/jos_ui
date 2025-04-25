import 'package:flutter/material.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/component/tile.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/module_controller.dart';
import 'package:jos_ui/dialog/module_information_dialog.dart';
import 'package:jos_ui/model/module.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ModulePage extends StatefulWidget {
  const ModulePage({super.key});

  @override
  State<ModulePage> createState() => _ModulePageState();
}

class _ModulePageState extends State<ModulePage> {
  final _moduleController = Get.put(ModuleController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((e) => _moduleController.fetchModules());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContent(
      controllers: [
        OutlinedButton(
          onPressed: () => Get.toNamed(Routes.moduleLogs.path),
          child: Icon(ModernPictograms.article, size: 16),
        ),
      ],
      child: SingleChildScrollView(
        child: Obx(
          () => ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _moduleController.moduleList.length,
            itemBuilder: (context, index) {
              var module = _moduleController.moduleList[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: TileItem(
                  actions: SizedBox(
                    width: 100,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // infoButton(module),
                        serviceButton(module),
                        deleteButton(module),
                      ],
                    ),
                  ),
                  subTitle: Text(
                    module.path,
                    style: TextStyle(fontSize: 14),
                  ),
                  index: index,
                  title: Text(module.name),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget deleteButton(Module module) {
    var name = module.name;
    return IconButton(
      onPressed: () => _moduleController.removeModule(name),
      splashRadius: 10,
      splashColor: Colors.transparent,
      icon: Icon(MdiIcons.trashCanOutline, size: 16, color: Colors.black),
    );
  }

  Widget serviceButton(Module module) {
    var name = module.name;
    var isStarted = module.started;
    return IconButton(
      onPressed: () => isStarted ? _moduleController.stopService(name) : _moduleController.startService(name),
      splashRadius: 10,
      splashColor: Colors.transparent,
      icon: Icon(isStarted ? Icons.pause : Icons.play_arrow, size: 16, color: Colors.black),
    );
  }

  Widget infoButton(Module module) {
    return IconButton(
      onPressed: () => displayModuleInformationModal(module),
      splashRadius: 10,
      splashColor: Colors.transparent,
      icon: Icon(Icons.info_outline, size: 16, color: Colors.black),
    );
  }
}
