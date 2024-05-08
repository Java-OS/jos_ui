import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/radio_tile_component.dart';
import 'package:jos_ui/component/tile_component.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/container_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';
import 'package:jos_ui/dialog/environment_dialog.dart';
import 'package:jos_ui/model/container/network_info.dart';
import 'package:jos_ui/utils.dart';
import 'package:jos_ui/widget/tab_widget.dart';
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
          child: Obx(
            () => Stepper(
              onStepContinue: () => _containerController.step.value++,
              onStepCancel: () => _containerController.step.value--,
              currentStep: _containerController.step.value,
              controlsBuilder: (context, controlDetails) {
                bool isAfterFirstStep = controlDetails.currentStep > 0;
                bool isLastStep = controlDetails.currentStep == 3;
                bool isImageSelected = _containerController.selectedImage.isNotEmpty;
                bool isNameFilled = _containerController.containerNameEditingController.text.isNotEmpty;
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
                        onPressed: isLastStep
                            ? _containerController.createContainer
                            : (isImageSelected && isNameFilled)
                                ? controlDetails.onStepContinue
                                : null,
                        child: Text(isLastStep ? 'Create container' : 'Next'),
                      ),
                    ),
                  ],
                );
              },
              steps: [
                Step(title: Text('Basic'), content: getBasicStep()),
                Step(title: Text('Volume'), content: getVolumeStep()),
                Step(title: Text('Network'), content: getNetworkStep()),
                Step(title: Text('Environment'), content: getEnvironmentStep()),
                // Step(title: Text('POD'), content: Text('Content 4')),
              ],
            ),
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
        TextFieldBox(controller: _containerController.containerHostnameEditingController, label: 'Hostname (Optional)'),
        SizedBox(height: 8),
        TextFieldBox(controller: _containerController.containerUserEditingController, label: 'User  (Optional)'),
        SizedBox(height: 8),
        TextFieldBox(controller: _containerController.containerWorkDirEditingController, label: 'Work Directory (Optional)'),
        SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: () => displaySelectContainerImage(),
            label: Text(_containerController.selectedImage.value.isEmpty ? 'Choose Image' : _containerController.selectedImage.value),
            icon: Icon(MdiIcons.layersTriple, size: 16, color: Colors.blue),
          ),
        ),
      ],
    ),
  );
}

/* Image */
Future<void> displaySelectContainerImage() async {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Select image'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        backgroundColor: componentBackgroundColor,
        children: [
          SizedBox(
            width: 400,
            height: 350,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: TabBox(
                tabs: const [
                  TabItem(text: 'Installed', icon: Icons.check_outlined, iconSize: 18, fontSize: 12, fontWeight: FontWeight.bold),
                  TabItem(text: 'Search', icon: Icons.search, iconSize: 18, fontSize: 12, fontWeight: FontWeight.bold),
                ],
                contents: [
                  installedImagesTab(),
                  searchImagesTab(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 50,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                child: Text('Apply'),
              ),
            ),
          )
        ],
      );
    },
  );
}

Widget installedImagesTab() {
  return Padding(
    padding: EdgeInsets.all(14.0),
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: _containerController.containerImageList.length,
      itemBuilder: (BuildContext context, int index) {
        var containerImage = _containerController.containerImageList[index];
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Obx(
            () => RadioTileComponent<String>(
              index: index,
              value: containerImage.name,
              selectedValue: _containerController.selectedImage.value,
              title: Text(containerImage.name),
              subTitle: Text(truncate(containerImage.id!)),
              onChanged: (value) => _containerController.selectedImage.value = value,
            ),
          ),
        );
      },
    ),
  );
}

Widget searchImagesTab() {
  return Padding(
    padding: EdgeInsets.all(14.0),
    child: Column(
      children: [
        TextField(
          controller: _containerController.searchImageEditingController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            suffix: ElevatedButton(onPressed: () => _containerController.searchImage(), child: Text('Search')),
          ),
        ),
        SizedBox(height: 8),
        Obx(
          () => Expanded(
            child: Visibility(
              visible: _containerController.waitingImageSearch.isFalse,
              replacement: Center(child: SpinKitCircle(color: Colors.blueAccent)),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _containerController.searchImageList.length,
                itemBuilder: (BuildContext context, int index) {
                  var imageSearch = _containerController.searchImageList[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Obx(
                      () => RadioTileComponent<String>(
                        index: index,
                        value: imageSearch.name,
                        selectedValue: _containerController.selectedImage.value,
                        title: Text(imageSearch.name),
                        subTitle: Text(truncate(imageSearch.index)),
                        onChanged: (value) => _containerController.selectedImage.value = value,
                      ),
                    ),
                  );
                },
              ),
            ),
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

/* Environments */
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
          SizedBox(
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
