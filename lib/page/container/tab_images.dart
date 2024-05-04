import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/tab_content.dart';
import 'package:jos_ui/component/tile_component.dart';
import 'package:jos_ui/controller/container_controller.dart';
import 'package:jos_ui/dialog/container_dialog.dart';
import 'package:jos_ui/utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OCITabImages extends StatefulWidget {
  const OCITabImages({super.key});

  @override
  State<OCITabImages> createState() => OCITabImagesState();
}

class OCITabImagesState extends State<OCITabImages> {
  final _containerController = Get.put(ContainerController());

  var _waitingListImages = false;

  @override
  void initState() {
    loadImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabContent(
      title: 'Images',
      toolbar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () => loadImages(),
            child: Icon(Icons.refresh, size: 16, color: Colors.black),
          ),
          SizedBox(width: 8),
          OutlinedButton(
            onPressed: () => displayContainerSearchImage(),
            child: Icon(Icons.add, size: 16, color: Colors.black),
          )
        ],
      ),
      content: Obx(
        () => Visibility(
          visible: !_waitingListImages,
          replacement: SpinKitCircle(color: Colors.blueAccent),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _containerController.containerImageList.length,
            itemBuilder: (BuildContext context, int index) {
              var containerImage = _containerController.containerImageList[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: TileComponent(
                  index: index,
                  leading: Visibility(
                    visible: containerImage.id!.isNotEmpty,
                    replacement: SizedBox(
                      width: 40,
                      height: 40,
                      child: SpinKitThreeBounce(
                        color: Colors.blue,
                        size: 20.0,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 18,
                      child: Text((index + 1).toString(), style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  title: Text(containerImage.name),
                  subTitle: Text(truncate(containerImage.id!)),
                  actions: Visibility(
                    visible: containerImage.id!.isNotEmpty,
                    replacement: IconButton(
                      splashRadius: 20,
                      icon: Icon(Icons.cancel, size: 16, color: Colors.black),
                      onPressed: () => _containerController.cancelPullImage(containerImage.name),
                    ),
                    child: IconButton(
                      splashRadius: 20,
                      icon: Icon(MdiIcons.trashCanOutline, size: 16, color: Colors.black),
                      onPressed: _containerController.waitingImageRemove.isTrue ? null : () => _containerController.removeImage(containerImage.id!),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void loadImages() async {
    setState(() => _waitingListImages = true);
    await _containerController.listImages();
    setState(() => _waitingListImages = false);
  }
}
