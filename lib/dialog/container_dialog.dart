import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/tile_component.dart';
import 'package:jos_ui/controller/container_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';
import 'package:jos_ui/model/container/network_info.dart';
import 'package:jos_ui/widget/text_field_box_widget.dart';

final _containerController = Get.put(ContainerController());

Future<void> displayContainerSearchImage() async {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Search Image'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
        titlePadding: EdgeInsets.zero,
        children: [
          TextField(
            controller: _containerController.searchImageEditingController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              suffix: ElevatedButton(onPressed: () => _containerController.searchImage(), child: Text('Search')),
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            width: 400,
            height: 250,
            child: Obx(
              () => Visibility(
                visible: _containerController.waitingImageSearch.isFalse,
                replacement: SpinKitCircle(color: Colors.blueAccent),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _containerController.searchImageList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var searchImage = _containerController.searchImageList[index];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TileComponent(
                        index: index + 1,
                        leading: Visibility(
                          visible: searchImage.tag != 'JOS_PULL_IMAGE',
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
                        title: Text(searchImage.name),
                        subTitle: Text(searchImage.index),
                        actions: _containerController.isImageInstalled(searchImage.name)
                            ? null
                            : Visibility(
                                visible: searchImage.tag != 'JOS_PULL_IMAGE',
                                replacement: IconButton(
                                  onPressed: () => _containerController.cancelPullImage(searchImage.name),
                                  splashRadius: 22,
                                  icon: Icon(Icons.cancel),
                                ),
                                child: IconButton(
                                  onPressed: () => _containerController.pullImage(searchImage.name),
                                  splashRadius: 22,
                                  icon: Icon(Icons.download),
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      );
    },
  ).then((_) => _containerController.clean());
}

Future<void> displayCreateVolume() async {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Create volume'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldBox(controller: _containerController.volumeNameEditingController, label: 'Name'),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(onPressed: () => _containerController.createVolume(), child: Text('Create')),
              ),
            ],
          )
        ],
      );
    },
  );
}

Future<void> displayCreateNetwork() async {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Create network'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldBox(controller: _containerController.networkNameEditingController, label: 'Name'),
              SizedBox(height: 8),
              TextFieldBox(controller: _containerController.networkSubnetEditingController, label: 'Network Range (Ex. 172.16.1.0/24)'),
              SizedBox(height: 8),
              TextFieldBox(controller: _containerController.networkGatewayEditingController, label: 'Gateway (Ex. 172.16.1.1)'),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(onPressed: () => _containerController.createNetwork(), child: Text('Create')),
              ),
            ],
          )
        ],
      );
    },
  );
}

Future<void> displayNetworkInfo(NetworkInfo ni) async {
  var columns = [
    DataColumn(label: Text('Key', style: TextStyle(fontWeight: FontWeight.bold))),
    DataColumn(label: Text('Value', style: TextStyle(fontWeight: FontWeight.bold))),
  ];

  var nameRow = DataRow(cells: [DataCell(Text(ni.name, style: TextStyle(fontSize: 12))), DataCell(Text(ni.name, style: TextStyle(fontSize: 12)))]);
  var interfaceRow = DataRow(cells: [DataCell(Text('Interface Name', style: TextStyle(fontSize: 12))), DataCell(Text(ni.networkInterface, style: TextStyle(fontSize: 12)))]);
  var subnetRow = DataRow(cells: [DataCell(Text('Subnet', style: TextStyle(fontSize: 12))), DataCell(Text(ni.subnets[0].subnet, style: TextStyle(fontSize: 12)))]);
  var gatewayRow = DataRow(cells: [DataCell(Text('Gateway', style: TextStyle(fontSize: 12))), DataCell(Text(ni.subnets[0].gateway, style: TextStyle(fontSize: 12)))]);
  var driverRow = DataRow(cells: [DataCell(Text('Driver', style: TextStyle(fontSize: 12))), DataCell(Text(ni.driver, style: TextStyle(fontSize: 12)))]);
  var dnsEnableRow = DataRow(cells: [DataCell(Text('DNS Activated', style: TextStyle(fontSize: 12))), DataCell(Text(ni.dnsEnabled.toString(), style: TextStyle(fontSize: 12)))]);
  var internalRow = DataRow(cells: [DataCell(Text('Internal Network', style: TextStyle(fontSize: 12))), DataCell(Text(ni.internal.toString(), style: TextStyle(fontSize: 12)))]);
  var rows = <DataRow>[nameRow, interfaceRow, subnetRow, gatewayRow, driverRow, dnsEnableRow, internalRow];

  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Network Information'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [DataTable(columns: columns, rows: rows)],
      );
    },
  );
}
