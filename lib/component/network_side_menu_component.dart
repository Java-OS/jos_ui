import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';

class NetworkSideMenuComponent extends StatefulWidget {
  const NetworkSideMenuComponent({super.key});

  @override
  State<NetworkSideMenuComponent> createState() => NetworkSideMenuComponentState();
}

class NetworkSideMenuComponentState extends State<NetworkSideMenuComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        menuItem(Routes.networkInterfaces.routeName, Icons.info_outline),
        menuItem(Routes.networkNetworks.routeName, Icons.hub_outlined),
        menuItem(Routes.networkHosts.routeName, Icons.devices_other_outlined),
      ],
    );
  }

  Widget menuItem(String path, IconData icon) {
    var isOnRoute = Get.currentRoute == path;
    return InkWell(
      onTap: () => Get.offAllNamed(path),
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
}
