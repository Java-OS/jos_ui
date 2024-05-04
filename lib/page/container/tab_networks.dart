import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/tab_content.dart';
import 'package:jos_ui/component/tile_component.dart';
import 'package:jos_ui/controller/container_controller.dart';
import 'package:jos_ui/dialog/container_dialog.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OCITabNetworks extends StatefulWidget {
  const OCITabNetworks({super.key});

  @override
  State<OCITabNetworks> createState() => _OCITabNetworksState();
}

class _OCITabNetworksState extends State<OCITabNetworks> {
  final _containerController = Get.put(ContainerController());
  var _waitingNetworksLoad = false;

  @override
  void initState() {
    loadNetworks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabContent(
      title: 'Networks',
      toolbar: OutlinedButton(
        onPressed: () => displayCreateNetwork(),
        child: Icon(Icons.add, size: 16, color: Colors.black),
      ),
      content: Obx(
        () => Visibility(
          visible: !_waitingNetworksLoad,
          replacement: SpinKitCircle(color: Colors.blueAccent),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _containerController.networkList.length,
            itemBuilder: (BuildContext context, int index) {
              var network = _containerController.networkList[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: TileComponent(
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
      ),
    );
  }

  void loadNetworks() async {
    setState(() => _waitingNetworksLoad = true);
    await _containerController.listNetworks();
    setState(() => _waitingNetworksLoad = false);
  }
}
