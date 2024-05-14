import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/tab_content.dart';
import 'package:jos_ui/controller/container_controller.dart';
import 'package:jos_ui/dialog/container/registry_dialog.dart';
import 'package:jos_ui/widget/tile_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OCITabSettings extends StatefulWidget {
  const OCITabSettings({super.key});

  @override
  State<OCITabSettings> createState() => OCITabSettingsState();
}

class OCITabSettingsState extends State<OCITabSettings> {
  final _containerController = Get.put(ContainerController());

  @override
  void initState() {
    loadRegistries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabContent(
      title: 'Registries',
      toolbar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(width: 8),
          OutlinedButton(
            onPressed: () => displayAddRegistryDialog(),
            child: Icon(Icons.add, size: 16, color: Colors.black),
          ),
        ],
      ),
      content: Obx(
        () => ListView.builder(
          shrinkWrap: true,
          itemCount: _containerController.registries.length,
          itemBuilder: (BuildContext context, int index) {
            var registry = _containerController.registries.toList()[index];
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: TileItem(
                index: index,
                title: Text(registry),
                actions: IconButton(
                  splashRadius: 20,
                  icon: Icon(MdiIcons.trashCanOutline, size: 16, color: Colors.black),
                  onPressed: () => _containerController.removeRegistries(registry),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void loadRegistries() async {
    await _containerController.loadRegistries();
  }
}
