import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/component/tile.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/oci_controller.dart';
import 'package:jos_ui/dialog/container/container_information.dart';
import 'package:jos_ui/dialog/log_dialog.dart';
import 'package:jos_ui/model/container/container_info.dart';
import 'package:jos_ui/utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OciContainerListPage extends StatefulWidget {
  const OciContainerListPage({super.key});

  @override
  State<OciContainerListPage> createState() => _OciContainerListPageState();
}

class _OciContainerListPageState extends State<OciContainerListPage> {
  final _containerController = Get.put(OciController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((e) => _containerController.listContainers());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContent(
      controllers: [
        OutlinedButton(
          onPressed: () => _containerController.pruneContainer(),
          child: Icon(MdiIcons.deleteSweepOutline, size: 16, color: Colors.black),
        ),
        SizedBox(width: 8),
        OutlinedButton(
          onPressed: () => _containerController.listContainers(),
          child: Icon(Icons.refresh, size: 16, color: Colors.black),
        ),
        SizedBox(width: 8),
        OutlinedButton(
          onPressed: () => Get.toNamed(Routes.ociContainerCreate.path),
          child: Icon(Icons.add, size: 16, color: Colors.black),
        ),
      ],
      child: Obx(
        () => ListView.builder(
          shrinkWrap: true,
          itemCount: _containerController.containerList.length,
          itemBuilder: (BuildContext context, int index) {
            var container = _containerController.containerList[index];
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: TileItem(
                leading: Visibility(
                  visible: container.id.isNotEmpty,
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
                index: index,
                title: Text(container.names[0]),
                subTitle: Text(truncate(container.id), style: TextStyle(fontSize: 12)),
                actions: SizedBox(
                  width: 140,
                  child: Visibility(
                    visible: container.state.isNotEmpty,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          splashRadius: 20,
                          icon: Icon(Icons.receipt_long_rounded, size: 16, color: Colors.black),
                          onPressed: () => displayContainerLogDialog(container.names[0]),
                        ),
                        IconButton(
                          splashRadius: 20,
                          icon: Icon(container.state == 'running' ? MdiIcons.stopCircleOutline : MdiIcons.playCircleOutline, size: 16, color: Colors.black),
                          onPressed: () => container.state == 'running' ? _containerController.stopContainer(container.id) : _containerController.startContainer(container.id),
                        ),
                        Visibility(
                          visible: container.state == 'running',
                          child: IconButton(
                            splashRadius: 20,
                            icon: Icon(MdiIcons.skullOutline, size: 16, color: Colors.red),
                            onPressed: () => _containerController.killContainer(container.id),
                          ),
                        ),
                        Visibility(
                          visible: container.state != 'running',
                          child: IconButton(
                            splashRadius: 20,
                            icon: Icon(MdiIcons.trashCanOutline, size: 16, color: Colors.black),
                            onPressed: () => _containerController.removeContainer(container.names[0], container.id),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                onClick: () => displayContainerInfo(container),
              ),
            );
          },
        ),
      ),
    );
  }
}
