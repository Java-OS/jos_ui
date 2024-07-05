import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/page_layout.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/page/container/tab_containers.dart';
import 'package:jos_ui/page/container/tab_images.dart';
import 'package:jos_ui/page/container/tab_networks.dart';
import 'package:jos_ui/page/container/tab_settings.dart';
import 'package:jos_ui/page/container/tab_volumes.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ContainerBasePage extends StatefulWidget {
  const ContainerBasePage({super.key});

  @override
  State<ContainerBasePage> createState() => ContainerBasePageState();
}

class ContainerBasePageState extends State<ContainerBasePage> {
  static const baseRoute = '/containers';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              sideMenu(0, MdiIcons.cubeOutline),
              sideMenu(1, MdiIcons.layersTriple),
              sideMenu(2, MdiIcons.sd),
              sideMenu(3, MdiIcons.networkOutline),
              sideMenu(4, MdiIcons.cog),
            ],
          ),
          Expanded(
            child: Container(
              height: 380,
              color: secondaryColor,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: chooseTargetTab(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sideMenu(int tabIndex, IconData icon) {
    var reqIndex = int.parse(Get.parameters['index'] ?? '0');
    var isOnRoute = reqIndex == tabIndex;
    return InkWell(
      onTap: () => Get.toNamed('$baseRoute/$tabIndex'),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2.0),
        child: AnimatedContainer(
          decoration: BoxDecoration(
            color: isOnRoute ? secondaryColor : Colors.white10,
          ),
          width: 80,
          height: 50,
          duration: Duration(milliseconds: 200),
          child: Center(
            child: Icon(icon, size: 22, color: isOnRoute ? Colors.blue : Colors.white38),
          ),
        ),
      ),
    );
  }

  Widget chooseTargetTab() {
    var tabIndex = Get.parameters['index'] ?? '0';
    switch (int.parse(tabIndex)) {
      case 0:
        return OCITabContainers();
      case 1:
        return OCITabImages();
      case 2:
        return OCITabVolumes();
      case 3:
        return OCITabNetworks();
      case 4:
        return OCITabSettings();
      default:
        return OCITabContainers();
    }
  }
}
