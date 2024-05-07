import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/tab_content.dart';
import 'package:jos_ui/component/tile_component.dart';
import 'package:jos_ui/controller/container_controller.dart';
import 'package:jos_ui/dialog/container/container_create_dialog.dart';
import 'package:jos_ui/dialog/container/container_information.dart';
import 'package:jos_ui/utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OCITabContainers extends StatefulWidget {
  const OCITabContainers({super.key});

  @override
  State<OCITabContainers> createState() => OCITabContainersState();
}

class OCITabContainersState extends State<OCITabContainers> {
  final _containerController = Get.put(ContainerController());
  var _waitingContainersLoad = false;

  @override
  void initState() {
    loadContainers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabContent(
      title: 'Containers',
      toolbar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () {},
            child: Icon(MdiIcons.deleteSweepOutline, size: 16, color: Colors.black),
          ),
          SizedBox(width: 8),
          OutlinedButton(
            onPressed: () => openCreateContainerDialog(),
            child: Icon(Icons.add, size: 16, color: Colors.black),
          )
        ],
      ),
      content: Obx(
        () => Visibility(
          visible: !_waitingContainersLoad,
          replacement: SpinKitCircle(color: Colors.blueAccent),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _containerController.containerList.length,
            itemBuilder: (BuildContext context, int index) {
              var container = _containerController.containerList[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: TileComponent(
                  leading: CircleAvatar(
                    radius: 18,
                    child: Text((index + 1).toString(), style: TextStyle(fontSize: 12)),
                  ),
                  index: index,
                  title: Text(container.names[0]),
                  subTitle: Text(truncate(container.id), style: TextStyle(fontSize: 12)),
                  actions: SizedBox(
                    width: 140,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
                            onPressed: () => _containerController.removeContainer(container.id),
                          ),
                        )
                      ],
                    ),
                  ),
                  onClick: () => displayContainerInfo(container),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void loadContainers() async {
    setState(() => _waitingContainersLoad = true);
    await _containerController.listContainers();
    setState(() => _waitingContainersLoad = false);
  }

  Future<void> openCreateContainerDialog() async {
    await _containerController.listVolumes();
    await _containerController.listNetworks();
    displayCreateContainer();
  }
}
