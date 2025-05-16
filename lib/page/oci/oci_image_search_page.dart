import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/component/tile.dart';
import 'package:jos_ui/controller/oci_controller.dart';

class OciImageSearchPage extends StatefulWidget {
  const OciImageSearchPage({super.key});

  @override
  State<OciImageSearchPage> createState() => _OciImageSearchPageState();
}

class _OciImageSearchPageState extends State<OciImageSearchPage> {
  final _containerController = Get.put(OciController());

  @override
  Widget build(BuildContext context) {
    return CardContent(
      child: Obx(
        () => Expanded(
          child: Column(
            children: [
              TextField(
                controller: _containerController.searchImageEditingController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  suffix: ElevatedButton(onPressed: () => _containerController.searchImage(), child: Text('Search')),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _containerController.searchImageList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var searchImage = _containerController.searchImageList[index];
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TileItem(
                          index: index + 1,
                          title: Text(searchImage.name),
                          subTitle: Text(searchImage.index),
                          actions: IconButton(
                            onPressed: () => _containerController.pullImage(searchImage.name),
                            icon: Icon(Icons.download_outlined, size: 16),
                            splashRadius: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
