import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/controller/container_controller.dart';
import 'package:jos_ui/dialog/container/image_search_dialog.dart';
import 'package:jos_ui/model/container/container_info.dart';
import 'package:jos_ui/model/event_code.dart';
import 'package:jos_ui/utils.dart';
import 'package:jos_ui/widget/tile_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OciImagesPage extends StatefulWidget {
  const OciImagesPage({super.key});

  @override
  State<OciImagesPage> createState() => _OciImagesPageState();
}

class _OciImagesPageState extends State<OciImagesPage> {
  final _containerController = Get.put(ContainerController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => loadImages());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContent(
      title: 'Images',
      controllers: [
        OutlinedButton(
          onPressed: () => loadImages(),
          child: Icon(Icons.refresh, size: 16, color: Colors.black),
        ),
        SizedBox(width: 8),
        OutlinedButton(
          onPressed: () => displayContainerSearchImage(),
          child: Icon(Icons.add, size: 16, color: Colors.black),
        ),
      ],
      child: Obx(
        () => Visibility(
          visible: _containerController.waitingListImages.isFalse,
          replacement: SpinKitCircle(color: Colors.blueAccent),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _containerController.containerImageList.length,
            itemBuilder: (BuildContext context, int index) {
              var containerImage = _containerController.containerImageList[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: TileItem(
                  index: index,
                  leading: Visibility(
                    visible: containerImage.id.isNotEmpty,
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
                  subTitle: Text(truncate(containerImage.id)),
                  actions: Visibility(
                    visible: containerImage.id.isNotEmpty,
                    replacement: IconButton(
                      splashRadius: 20,
                      icon: Icon(Icons.cancel, size: 16, color: Colors.black),
                      onPressed: () => _containerController.cancelPullImage(containerImage.name),
                    ),
                    child: IconButton(
                      splashRadius: 20,
                      icon: Icon(MdiIcons.trashCanOutline, size: 16, color: Colors.black),
                      onPressed: () => removeImage(containerImage.id),
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

  Future<void> streamLogs(ContainerInfo container) async {
    _containerController.containerSSEConsumer(container.names.first, EventCode.containerLogs);
  }

  void loadImages() async {
    _containerController.waitingListImages.value = true;
    await _containerController.listImages();
    _containerController.waitingListImages.value = false;
  }

  void removeImage(String imageId) async {
    _containerController.waitingListImages.value = true;
    _containerController.removeImage(imageId);
    _containerController.waitingListImages.value = false;
  }
}
