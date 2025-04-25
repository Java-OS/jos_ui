import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/component/tile.dart';
import 'package:jos_ui/controller/module_controller.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DependencyPage extends StatefulWidget {
  const DependencyPage({super.key});

  @override
  State<DependencyPage> createState() => _DependencyPageState();
}

class _DependencyPageState extends State<DependencyPage> {
  final _moduleController = Get.put(ModuleController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((e) => _moduleController.fetchDependencyLayers());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContent(
      controllers: [
        if (!_moduleController.doSelectItems.value) OutlinedButton(onPressed: () => _moduleController.fetchDependencyLayers(), child: Icon(Icons.refresh, size: 16)),
      ],
      child: SingleChildScrollView(
        child: Obx(
          () => ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _moduleController.dependencies.length,
            itemBuilder: (context, index) {
              var dep = _moduleController.dependencies[index];
              return Obx(
                () => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TileItem(
                    actions: Visibility(
                      visible: _moduleController.doSelectItems.value,
                      child: SizedBox(
                        width: 100,
                        child: Checkbox(
                          value: _moduleController.isDependencySelected(dep),
                          onChanged: (e) => _moduleController.updateSelectedDependencies(dep, e!),
                        ),
                      ),
                    ),
                    subTitle: Text(
                      dep.path,
                      style: TextStyle(fontSize: 14),
                    ),
                    index: index,
                    title: Text(dep.name),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget deleteButton(String name) {
    return IconButton(
      onPressed: () => _moduleController.removeModule(name),
      splashRadius: 10,
      splashColor: Colors.transparent,
      icon: Icon(MdiIcons.trashCanOutline, size: 16),
    );
  }

  @override
  void dispose() {
    developer.log('Dispose dependency page');
    _moduleController.clear();
    super.dispose();
  }
}
