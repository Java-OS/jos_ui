import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/tab_content.dart';
import 'package:jos_ui/component/tile_component.dart';
import 'package:jos_ui/controller/container_controller.dart';
import 'package:jos_ui/controller/system_controller.dart';
import 'package:jos_ui/dialog/container_dialog.dart';
import 'package:jos_ui/dialog/filesystem_dialog.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OCITabVolumes extends StatefulWidget {
  const OCITabVolumes({super.key});

  @override
  State<OCITabVolumes> createState() => OCITabVolumesState();
}

class OCITabVolumesState extends State<OCITabVolumes> {
  final _containerController = Get.put(ContainerController());
  final _systemController = Get.put(SystemController());
  var _waitingVolumeLoad = false;

  @override
  void initState() {
    loadVolumes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabContent(
      title: 'Volumes',
      toolbar: OutlinedButton(
        onPressed: () => displayCreateVolume(),
        child: Icon(Icons.add, size: 16, color: Colors.black),
      ),
      content: Obx(
        () => Visibility(
          visible: !_waitingVolumeLoad,
          replacement: SpinKitCircle(color: Colors.blueAccent),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _containerController.volumeList.length,
            itemBuilder: (BuildContext context, int index) {
              var volume = _containerController.volumeList[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: TileComponent(
                  index: index,
                  title: Text(volume.name!),
                  actions: IconButton(
                    splashRadius: 20,
                    icon: Icon(MdiIcons.trashCanOutline, size: 16, color: Colors.black),
                    onPressed: () => _containerController.removeVolume(volume.name!),
                  ),
                  onClick: () => fetchTreeAndDisplay(volume.mountPoint),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void loadVolumes() async {
    setState(() => _waitingVolumeLoad = true);
    await _containerController.listVolumes();
    setState(() => _waitingVolumeLoad = false);
  }

  fetchTreeAndDisplay(String path) {
    _systemController.fetchFilesystemTree(path).then((value) => displayFilesystemTree(true));
  }
}
