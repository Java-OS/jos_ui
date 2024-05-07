import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/tile_component.dart';
import 'package:jos_ui/controller/container_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';
import 'package:jos_ui/model/container/network_info.dart';
import 'package:jos_ui/widget/text_field_box_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

final _containerController = Get.put(ContainerController());

Future<void> displayCreateContainer() async {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        title: getModalHeader('Create container'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        content: SizedBox(
          width: 500,
          height: 400,
          child: Stepper(
            currentStep: 2,
            steps: [
              Step(title: Text('Basic'), content: getBasicStep()),
              Step(title: Text('Volume'), content: getVolumeStep()),
              Step(title: Text('Network'), content: getNetworkStep()),
              Step(title: Text('POD'), content: Text('Content 4')),
            ],
          ),
        ),
      );
    },
  );
}

Widget getBasicStep() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        TextFieldBox(controller: _containerController.containerNameEditingController, label: 'Name'),
        SizedBox(height: 8),
        TextFieldBox(controller: _containerController.containerHostnameEditingController, label: 'Hostname'),
        SizedBox(height: 8),
        TextFieldBox(controller: _containerController.containerUserEditingController, label: 'User  (Optional)'),
        SizedBox(height: 8),
        TextFieldBox(controller: _containerController.containerWorkDirEditingController, label: 'Work Directory (Optional)'),
        SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: () {},
            label: Text('Choose Image'),
            icon: Icon(MdiIcons.layersTriple, size: 16, color: Colors.blue),
          ),
        ),
      ],
    ),
  );
}

/* Volume */
Widget getVolumeStep() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Obx(
      () => Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () => displayConnectVolumeToContainerDialog(),
              label: Text('Connect volume'),
              icon: Icon(MdiIcons.layersTriple, size: 16, color: Colors.blue),
            ),
          ),
          SizedBox(height: 8),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _containerController.connectVolumes.length,
            itemBuilder: (BuildContext context, int index) {
              var name = _containerController.connectVolumes[index].name;
              var mountPoint = _containerController.connectVolumes[index].dest;
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TileComponent(
                  index: index,
                  title: Text(name),
                  subTitle: Text(mountPoint, style: TextStyle(fontSize: 12)),
                  actions: IconButton(
                    onPressed: () => _containerController.connectVolumes.removeAt(index),
                    splashRadius: 16,
                    icon: Icon(MdiIcons.trashCanOutline, size: 16, color: Colors.black),
                  ),
                ),
              );
            },
          )
        ],
      ),
    ),
  );
}

Future<void> displayConnectVolumeToContainerDialog() async {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        title: getModalHeader('Connect volume'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField2<String>(
                  isDense: true,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (e) => _containerController.volumeNameEditingController.text = e!,
                  hint: const Text('Select Volume', style: TextStyle(fontSize: 14)),
                  items: _containerController.volumeList.map((e) => DropdownMenuItem(value: e.name!, child: Text(e.name!))).toList()),
              SizedBox(height: 8),
              TextFieldBox(
                controller: _containerController.volumeMountPointEditingController,
                label: 'Mount Point',
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () => _containerController.applyVolumeToContainer(),
                  child: Text('Apply'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/* Network */
Widget getNetworkStep() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Obx(
      () => Column(
        children: [
          TextFieldBox(controller: _containerController.containerDnsServerEditingController, label: 'DNS Nameserver (Optional, Max 3 ip, Comma delimited)'),
          SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () => displayConnectNetworkToContainerDialog(),
              label: Text('Connect network'),
              icon: Icon(MdiIcons.networkOutline, size: 16, color: Colors.blue),
            ),
          ),
          SizedBox(height: 8),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _containerController.networkConnect.length,
            itemBuilder: (BuildContext context, int index) {
              var name = _containerController.networkConnect.keys.toList()[index];
              var netInfo = _containerController.networkConnect[name];
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TileComponent(
                  index: index,
                  title: Text(name),
                  subTitle: netInfo!.staticIps != null &&  netInfo.staticIps!.isNotEmpty ? Text(netInfo.staticIps![0], style: TextStyle(fontSize: 12)) : null,
                  actions: IconButton(
                    onPressed: () => _containerController.networkConnect.removeWhere((k, v) => k == name),
                    splashRadius: 16,
                    icon: Icon(MdiIcons.trashCanOutline, size: 16, color: Colors.black),
                  ),
                ),
              );
            },
          )
        ],
      ),
    ),
  );
}

Future<void> displayConnectNetworkToContainerDialog() async {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        title: getModalHeader('Connect network'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField2<NetworkInfo>(
                isDense: true,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                onChanged: (e) => _containerController.selectedNetwork.value = e,
                hint: const Text('Select Network', style: TextStyle(fontSize: 14)),
                items: _containerController.networkList.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(),
              ),
              SizedBox(height: 8),
              TextFieldBox(controller: _containerController.containerIpAddressEditingController, label: 'IP address (Optional)'),
              SizedBox(height: 8),
              TextFieldBox(controller: _containerController.containerMacAddressEditingController, label: 'MAC address (Optional)'),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () => _containerController.applyNetworkToContainer(),
                  child: Text('Apply'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
