import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/controller/oci_controller.dart';
import 'package:jos_ui/dialog/container/create_network_dialog.dart';
import 'package:jos_ui/dialog/container/network_information_dialog.dart';
import 'package:jos_ui/widget/tile_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OciNetworksPage extends StatefulWidget {
  const OciNetworksPage({super.key});

  @override
  State<OciNetworksPage> createState() => _OciImagesPageState();
}

class _OciImagesPageState extends State<OciNetworksPage> {
  final _containerController = Get.put(OciController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((e) => _containerController.listNetworks());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContent(
      controllers: [
        OutlinedButton(
          onPressed: () => displayCreateNetwork(),
          child: Icon(Icons.add, size: 16, color: Colors.black),
        ),
      ],
      child: Obx(
        () => ListView.builder(
          shrinkWrap: true,
          itemCount: _containerController.networkList.length,
          itemBuilder: (BuildContext context, int index) {
            var network = _containerController.networkList[index];
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: TileItem(
                index: index,
                title: Text(network.name),
                actions: IconButton(
                  splashRadius: 20,
                  icon: Icon(MdiIcons.trashCanOutline, size: 16, color: Colors.black),
                  onPressed: () => _containerController.removeNetwork(network.name),
                ),
                onClick: () => displayNetworkInfo(network),
              ),
            );
          },
        ),
      ),
    );
  }
}
