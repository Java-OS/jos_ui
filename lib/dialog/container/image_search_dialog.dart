import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/tile.dart';
import 'package:jos_ui/controller/oci_controller.dart';
import 'package:jos_ui/dialog/base_dialog.dart';
import 'package:jos_ui/service/api_service.dart';

final _containerController = Get.put(OciController());
final _apiService = Get.put(ApiService());

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
                visible: _apiService.isLoading.isFalse,
                replacement: SpinKitCircle(color: Colors.blueAccent),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _containerController.searchImageList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var searchImage = _containerController.searchImageList[index];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TileItem(
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
