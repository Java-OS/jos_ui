import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/page/network/tab_hosts.dart';
import 'package:jos_ui/page/network/tab_interfaces.dart';
import 'package:jos_ui/page/network/tab_networks.dart';
import 'package:jos_ui/page_base_content.dart';

class NetworkBasePage extends StatefulWidget {
  const NetworkBasePage({super.key});

  @override
  State<NetworkBasePage> createState() => NetworkBasePageState();
}

class NetworkBasePageState extends State<NetworkBasePage> {
  static const baseRoute = '/networks';

  @override
  Widget build(BuildContext context) {
    return getPageContent(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              sideMenu(0, Icons.info_outline),
              sideMenu(1, Icons.hub_outlined),
              sideMenu(2, Icons.devices_other_outlined),
            ],
          ),
          tabContent(),
        ],
      ),
    );
  }

  Widget tabContent() {
    return Expanded(
      child: Container(
        height: 380,
        color: componentBackgroundColor,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: chooseTargetTab(),
        ),
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
            color: isOnRoute ? componentBackgroundColor : Colors.white10,
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
        return TabInterfaces();
      case 1:
        return TabNetworks();
      case 2:
        return TabHosts();
      default:
        return TabInterfaces();
    }
  }
}