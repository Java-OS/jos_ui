import 'dart:convert';

import 'package:get/get.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/service/rest_client.dart';
import 'package:jos_ui/widget/toast.dart';

class ApiService extends GetxController {
  var isLoading = false.obs;

  Future<dynamic> callApi(Rpc rpc, {Map<String, dynamic>? parameters, String? message, MessageType type = MessageType.warning, bool disableLoading = false}) async {
    isLoading.value = !disableLoading;
    var payload = await RestClient.rpc(rpc, parameters: parameters);
    if (payload.metadata!.success) {
      var content = payload.content;
      isLoading.value = false;
      return content != null ? jsonDecode(content) : [];
    } else {
      switch (type) {
        case MessageType.info:
          displayInfo(message!);
        case MessageType.warning:
          displayWarning(message!);
        case MessageType.error:
          displayError(message!);
        case MessageType.success:
          displaySuccess(message!);
      }
      isLoading.value = false;
    }
  }
}
