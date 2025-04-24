import 'dart:convert';

import 'package:get/get.dart';
import 'package:jos_ui/component/toast.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:jos_ui/service/rest_client.dart';

class ApiService extends GetxController {
  var isLoading = false.obs;

  Future<dynamic> callApi(Rpc rpc, {Map<String, dynamic>? parameters, String? message, MessageType type = MessageType.warning, bool disableLoading = false}) async {
    isLoading.value = !disableLoading;
    var payload = await RestClient.rpc(rpc, parameters: parameters);
    if (payload.metadata!.success) {
      var content = payload.content;
      isLoading.value = false;
      if (content != null) {
        var decode = jsonDecode(utf8.decode(content));
        return decode;
      } else {
        return [];
      }
    } else {
      var respMetaMessage = payload.metadata!.message ;
      if (respMetaMessage != null) {
        switch (type) {
          case MessageType.info:
            displayInfo(respMetaMessage);
          case MessageType.warning:
            displayWarning(respMetaMessage);
          case MessageType.error:
            displayError(respMetaMessage);
          case MessageType.success:
            displaySuccess(respMetaMessage);
        }
      }
      isLoading.value = false;
    }
  }
}
