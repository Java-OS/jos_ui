import 'dart:developer' as developer;

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/toast.dart';
import 'package:jos_ui/service/rest_client.dart';

class UploadDownloadController extends GetxController {
  var files = <PlatformFile>[].obs;
  var target = ''.obs;
  var inProgressItem = ''.obs;
  var isCancel = false.obs;
  var percentage = 0.0.obs;
  var count = 0.obs;
  var index = 0.obs;

  Future<void> upload() async {
    for (var i = 0; i < files.length; i++) {
      reset();
      count.value = files.length;
      index.value = i + 1;
      var fileName = files[i].name;
      var bytes = files[i].bytes!;
      inProgressItem.value = fileName;
      developer.log('Upload file: $fileName to: $target');
      try {
        await RestClient.upload(fileName, target.value, bytes);
      } catch (e) {
        displayWarning('$e');
        break;
      }
      if (isCancel.value) break;
    }
  }

  void reset() {
    percentage = 0.0.obs;
    count = 0.obs;
    index = 0.obs;
    isCancel = false.obs;
    inProgressItem.value = '';
  }

  @override
  void onClose() {
    reset();
    files = <PlatformFile>[].obs;
    target = ''.obs;
    super.onClose();
  }
}
