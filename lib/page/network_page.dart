import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/host_component.dart';
import 'package:jos_ui/component/ethernet_component.dart';
import 'package:jos_ui/component/network_component.dart';
import 'package:jos_ui/component/side_menu_component.dart';
import 'package:jos_ui/component/top_menu_component.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/page_base_content.dart';

class NetworkPage extends StatefulWidget {
  const NetworkPage({super.key});

  @override
  State<NetworkPage> createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  final menuItems = [
    Icons.info_outline,
    Icons.hub_outlined,
    Icons.devices_other_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return getPageContent(
      child: Center(
        child: SizedBox(
          width: 600,
          height: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopMenuComponent(),
              SizedBox(height: 8),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SideMenuComponent(menuItems: menuItems, baseMenuPath: 'network'),
                    chooseTargetTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget chooseTargetTab() {
    var tabIndex = Get.parameters['index'] ?? '0';
    switch (int.parse(tabIndex)) {
      case 0:
        return displayBasicSettings();
      case 1:
        return displayNetworkSettings();
      case 2:
        return displayHostSettings();
      default:
        return displayBasicSettings();
    }
  }

  Widget displayBasicSettings() {
    return basicContent(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Ethernet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
          Divider(),
          EthernetComponent(),
        ],
      ),
    );
  }

  Widget displayNetworkSettings() {
    return basicContent(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Networks', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
          Divider(),
          NetworkComponent(),
        ],
      ),
    );
  }

  Widget displayHostSettings() {
    return basicContent(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Hosts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
          Divider(),
          HostComponent(),
        ],
      ),
    );
  }

  Widget basicContent({child}) {
    return Expanded(
      child: Container(
        color: componentBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}
