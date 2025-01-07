import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/controller/oci_controller.dart';
import 'package:jos_ui/dialog/container/registry_dialog.dart';
import 'package:jos_ui/widget/tile_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OciSettingsPage extends StatefulWidget {
  const OciSettingsPage({super.key});

  @override
  State<OciSettingsPage> createState() => _OciSettingsPageState();
}

class _OciSettingsPageState extends State<OciSettingsPage> {
  final _containerController = Get.put(OciController());

  @override
  void initState() {
    loadRegistries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContent(
      title: 'Registries',
      controllers: [
        OutlinedButton(
          onPressed: () => displayAddRegistryDialog(),
          child: Icon(Icons.add, size: 16, color: Colors.black),
        ),
      ],
      child: Obx(
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
