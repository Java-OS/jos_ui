import 'dart:developer' as developer;

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/component/radio_tile.dart';
import 'package:jos_ui/component/text_field_box.dart';
import 'package:jos_ui/component/tile.dart';
import 'package:jos_ui/controller/oci_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';
import 'package:jos_ui/dialog/environment_dialog.dart';
import 'package:jos_ui/model/container/network_info.dart';
import 'package:jos_ui/model/firewall/protocol.dart';
import 'package:jos_ui/service/api_service.dart';
import 'package:jos_ui/util/utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OciContainerCreatePage extends StatefulWidget {
  const OciContainerCreatePage({super.key});

  @override
  State<OciContainerCreatePage> createState() => _OciContainerCreatePageState();
}

class _OciContainerCreatePageState extends State<OciContainerCreatePage> {
  final _containerController = Get.put(OciController());
  final _apiService = Get.put(ApiService());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((e) {
      _containerController.listImages(false);
      _containerController.listVolumes(true);
      _containerController.listNetworks(true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContent(
      child: Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Obx(
            () => Stepper(
              onStepContinue: () => _containerController.step.value++,
              onStepCancel: () => _containerController.step.value--,
              currentStep: _containerController.step.value,
              controlsBuilder: (BuildContext context, ControlsDetails controlDetails) {
                bool isAfterFirstStep = controlDetails.currentStep > 0;
                bool isLastStep = controlDetails.currentStep == steps().length - 1;
                return Row(
                  children: [
                    Visibility(
                      visible: isAfterFirstStep,
                      child: Expanded(
                        child: ElevatedButton(
                          onPressed: controlDetails.onStepCancel,
                          child: Text('Previous'),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => createContainer(controlDetails, isLastStep),
                        child: Text(isLastStep ? 'Create container' : 'Next'),
                      ),
                    ),
                  ],
                );
              },
              steps: steps(),
            ),
          ),
        ),
      ),
    );
  }

  List<Step> steps() {
    return [
      Step(title: Text('Image'), content: getImageStep()),
      Step(title: Text('Basic'), content: getBasicStep()),
      Step(title: Text('Volume'), content: getVolumeStep()),
      Step(title: Text('Network'), content: getNetworkStep()),
      Step(title: Text('Port'), content: getPortStep()),
      Step(title: Text('Environment'), content: getEnvironmentStep()),
      Step(title: Text('Command'), content: getCommandStep()),
    ];
  }

  void createContainer(ControlsDetails controlDetails, bool isLastStep) async {
    developer.log('Selected image: ${_containerController.selectedImage.value}');
    if (isLastStep) {
      await _containerController.createContainer();
      Get.back();
    }
    if (_containerController.selectedImage.isNotEmpty) {
      controlDetails.onStepContinue!();
    }
  }

  /*------ Basic ------*/
  Widget getBasicStep() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextFieldBox(controller: _containerController.containerNameEditingController, label: 'Name (Optional)'),
          SizedBox(height: 8),
          TextFieldBox(controller: _containerController.containerUserEditingController, label: 'User  (Optional)'),
          SizedBox(height: 8),
          TextFieldBox(controller: _containerController.containerWorkDirEditingController, label: 'Work Directory (Optional)'),
        ],
      ),
    );
  }

  /*------ Choose Image ------*/
  Widget getImageStep() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _containerController.containerImageList.length,
        itemBuilder: (BuildContext context, int index) {
          var containerImage = _containerController.containerImageList[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Obx(
              () => RadioTileItem<String>(
                index: index,
                value: containerImage.name,
                selectedValue: _containerController.selectedImage.value,
                title: Text(containerImage.name),
                subTitle: Text(truncate(containerImage.id)),
                onChanged: (value) => _containerController.selectedImage.value = value,
              ),
            ),
          );
        },
      ),
    );
  }

  /*------ Volume ------*/
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
                icon: Icon(MdiIcons.sd, size: 16, color: Colors.blue),
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
                  child: TileItem(
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
                    child: Text('Add'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /*------ Network ------*/
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
                  child: TileItem(
                    index: index,
                    title: Text(name),
                    subTitle: netInfo!.staticIps != null && netInfo.staticIps!.isNotEmpty ? Text(netInfo.staticIps![0], style: TextStyle(fontSize: 12)) : null,
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
                  buttonStyleData: ButtonStyleData(height: 60),
                  isDense: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (e) => _containerController.selectedNetwork.value = e,
                  hint: const Text('Select Network', style: TextStyle(fontSize: 14)),
                  menuItemStyleData: MenuItemStyleData(height: 60),
                  items: _containerController.networkList.map((e) => DropdownMenuItem(value: e, child: getNetworkName(e))).toList(),
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
    ).then((_) => _containerController.clearNetworkParameters());
  }

  Widget getNetworkName(NetworkInfo ni) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(ni.name),
        Text('Subnet: ${ni.subnets[0].subnet}     Gateway: ${ni.subnets[0].gateway}', style: TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }

  /*------ Ports ------*/
  Widget getPortStep() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(
        () => Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () => displayExposePortDialog(),
                      label: Text('Expose Port'),
                      icon: Icon(MdiIcons.link, size: 16, color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () => displayPublishPortDialog(),
                      label: Text('Publish Port'),
                      icon: Icon(MdiIcons.vectorLink, size: 16, color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            /* Publish ports */
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _containerController.portMappings.length,
              itemBuilder: (BuildContext context, int index) {
                var portMapping = _containerController.portMappings[index];
                var hostIp = portMapping.hostIp;
                var hostPort = portMapping.hostPort;
                var containerPort = portMapping.containerPort;
                var protocol = portMapping.protocol;
                var range = portMapping.range;
                var portMap = range == null ? '$hostPort:$containerPort/${protocol.name}' : '$containerPort-${containerPort + range}/${protocol.name}';
                var text = hostIp != null ? '$hostIp:$portMap' : portMap;
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TileItem(
                    index: index,
                    title: Text(text),
                    subTitle: range != null ? Text('Range: $range', style: TextStyle(fontSize: 12)) : null,
                    actions: IconButton(
                      onPressed: () => _containerController.removePublishPort(index),
                      splashRadius: 16,
                      icon: Icon(MdiIcons.trashCanOutline, size: 16, color: Colors.black),
                    ),
                  ),
                );
              },
            ),
            /* Expose ports */
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _containerController.expose.length,
              itemBuilder: (BuildContext context, int index) {
                var port = _containerController.expose.keys.toList()[index];
                var protocol = _containerController.expose[port];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TileItem(
                    index: index,
                    title: Text('$port/${protocol!.name}'),
                    actions: IconButton(
                      onPressed: () => _containerController.removeExposePort(port),
                      splashRadius: 16,
                      icon: Icon(MdiIcons.trashCanOutline, size: 16, color: Colors.black),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> displayExposePortDialog() async {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: getModalHeader('Expose port'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          contentPadding: EdgeInsets.all(14),
          titlePadding: EdgeInsets.zero,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldBox(
                  controller: _containerController.containerPortEditingController,
                  label: 'Port',
                ),
                SizedBox(height: 8),
                Obx(
                  () => Row(
                    children: [
                      Row(
                        children: [
                          Text('TCP'),
                          Radio(value: Protocol.tcp, groupValue: _containerController.selectedProtocol.value, onChanged: (e) => _containerController.changeProtocol(e!)),
                        ],
                      ),
                      SizedBox(width: 8),
                      Row(
                        children: [
                          Text('UDP'),
                          Radio(value: Protocol.udp, groupValue: _containerController.selectedProtocol.value, onChanged: (e) => _containerController.changeProtocol(e!)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(onPressed: () => _containerController.addExposePort(), child: Text('Add')),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Future<void> displayPublishPortDialog() async {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: getModalHeader('Publish port'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          contentPadding: EdgeInsets.all(14),
          titlePadding: EdgeInsets.zero,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldBox(controller: _containerController.hostIpEditingController, label: 'Host ip address'),
                SizedBox(height: 8),
                TextFieldBox(controller: _containerController.hostPortEditingController, label: 'Host port'),
                SizedBox(height: 8),
                TextFieldBox(controller: _containerController.containerPortEditingController, label: 'Container Port'),
                SizedBox(height: 8),
                TextFieldBox(controller: _containerController.rangeEditingController, label: 'Port Range'),
                SizedBox(height: 8),
                Obx(
                  () => Row(
                    children: [
                      Row(
                        children: [
                          Text('TCP'),
                          Radio(value: Protocol.tcp, groupValue: _containerController.selectedProtocol.value, onChanged: (e) => _containerController.changeProtocol(e!)),
                        ],
                      ),
                      SizedBox(width: 8),
                      Row(
                        children: [
                          Text('UDP'),
                          Radio(value: Protocol.udp, groupValue: _containerController.selectedProtocol.value, onChanged: (e) => _containerController.changeProtocol(e!)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(onPressed: () => _containerController.addPublishPort(), child: Text('Add')),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  /*------ Environments ------*/
  Widget getEnvironmentStep() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(
        () => Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () => displayAddEnvironmentDialog(_containerController.containerEnvironmentKeyEditingController, _containerController.containerEnvironmentValueEditingController, _containerController.addEnvironment),
                label: Text('Add environment'),
                icon: Icon(Icons.join_right, size: 16, color: Colors.blue),
              ),
            ),
            SizedBox(height: 8),
            Visibility(
              visible: _containerController.environments.isNotEmpty,
              child: SizedBox(
                width: double.infinity,
                height: 150,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    dataRowMinHeight: 12,
                    dataRowMaxHeight: 28,
                    columnSpacing: 0,
                    columns: getEnvironmentColumns(),
                    rows: getEnvironmentRows(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> getEnvironmentColumns() {
    var keyColumn = DataColumn(label: Text('Key', style: TextStyle(fontWeight: FontWeight.bold)));
    var valueColumn = DataColumn(label: Text('Value', style: TextStyle(fontWeight: FontWeight.bold)));
    var emptyColumn = DataColumn(label: SizedBox(width: 60));
    return [keyColumn, valueColumn, emptyColumn];
  }

  List<DataRow> getEnvironmentRows() {
    var listItems = <DataRow>[];
    _containerController.environments.forEach((key, value) {
      var row = DataRow(cells: [
        DataCell(
          Tooltip(
            preferBelow: false,
            message: key,
            child: Text(truncateWithEllipsis(10, key), style: TextStyle(fontSize: 12)),
          ),
        ),
        DataCell(
          Tooltip(
            preferBelow: false,
            message: value,
            child: Text(truncateWithEllipsis(50, value), style: TextStyle(fontSize: 12)),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 80,
              child: Row(
                children: [
                  IconButton(onPressed: () => _containerController.removeEnvironment(key), splashRadius: 12, icon: Icon(MdiIcons.trashCanOutline, size: 16, color: Colors.black)),
                  IconButton(
                    onPressed: () => displayUpdateEnvironmentDialog(_containerController.containerEnvironmentKeyEditingController, _containerController.containerEnvironmentValueEditingController, key, value, _containerController.updateEnvironment),
                    splashRadius: 12,
                    icon: Icon(MdiIcons.pencilOutline, size: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]);
      listItems.add(row);
    });
    return listItems;
  }

  /*------ Command ------*/
  Widget getCommandStep() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextFieldBox(controller: _containerController.commandEditingController, label: 'CMD (Optional)'),
        ],
      ),
    );
  }
}
