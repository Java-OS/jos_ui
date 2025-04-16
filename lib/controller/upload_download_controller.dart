import 'dart:developer' as developer;

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/toast.dart';
import 'package:jos_ui/controller/filesystem_controller.dart';
import 'package:jos_ui/model/filesystem_tree.dart';
import 'package:jos_ui/service/rest_client.dart';

class UploadDownloadController extends GetxController {
  final _filesystemController = Get.put(FilesystemController());
  var uploadFiles = <PlatformFile>[].obs;
  var downloadFile = Rxn<FilesystemTree>();
  var target = ''.obs;
  var inProgressItem = ''.obs;
  var isCancel = false.obs;
  var percentage = 0.0.obs;
  var count = 0.obs;
  var index = 0.obs;

  Future<void> upload() async {
    for (var i = 0; i < uploadFiles.length; i++) {
      reset();
      count.value = uploadFiles.length;
      index.value = i + 1;
      var fileName = uploadFiles[i].name;
      var bytes = uploadFiles[i].bytes!;
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

    if (!isCancel.value) {
      await _filesystemController.fetchFilesystemTree();
    }
  }

  Future<void> download() async {
    index.value = 1;
    count.value = 1;
    inProgressItem.value = downloadFile.value!.name;
    await RestClient.download(downloadFile.value!.fullPath);
    reset();
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
    uploadFiles = <PlatformFile>[].obs;
    target = ''.obs;
    super.onClose();
  }
}
