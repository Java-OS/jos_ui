import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/controller/filesystem_controller.dart';
import 'package:jos_ui/controller/oci_controller.dart';
import 'package:jos_ui/dialog/container/create_volume_dialog.dart';
import 'package:jos_ui/dialog/filesystem_dialog.dart';
import 'package:jos_ui/widget/tile_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OciVolumesPage extends StatefulWidget {
  const OciVolumesPage({super.key});

  @override
  State<OciVolumesPage> createState() => _OciImagesPageState();
}

class _OciImagesPageState extends State<OciVolumesPage> {
  final _containerController = Get.put(OciController());
  final _filesystemController = Get.put(FilesystemController());
  var _waitingVolumeLoad = false;

  @override
  void initState() {
    loadVolumes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContent(
      controllers: [
        OutlinedButton(
          onPressed: () => pruneVolumes(),
          child: Icon(MdiIcons.deleteSweepOutline, size: 16, color: Colors.black),
        ),
        SizedBox(width: 8),
        OutlinedButton(
          onPressed: () => displayCreateVolume(),
          child: Icon(Icons.add, size: 16, color: Colors.black),
        ),
      ],
      child: Obx(
        () => Visibility(
          visible: !_waitingVolumeLoad,
          replacement: Expanded(child: SpinKitCircle(color: Colors.blueAccent)),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _containerController.volumeList.length,
            itemBuilder: (BuildContext context, int index) {
              var volume = _containerController.volumeList[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: TileItem(
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

  void pruneVolumes() async {
    setState(() => _waitingVolumeLoad = true);
    await _containerController.pruneVolume();
    setState(() => _waitingVolumeLoad = false);
  }

  fetchTreeAndDisplay(String path) {
    _filesystemController.fetchFilesystemTree(path).then((value) => displayFilesystemTree(true, true));
  }
}
