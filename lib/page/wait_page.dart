import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/authentication_controller.dart';
import 'package:jos_ui/page_base_content.dart';
import 'package:jos_ui/service/RpcProvider.dart';
import 'package:jos_ui/service/storage_service.dart';

class WaitPage extends StatefulWidget {
  const WaitPage({super.key});

  @override
  State<WaitPage> createState() => _WaitPageState();
}

class _WaitPageState extends State<WaitPage> {
  AuthenticationController authenticationController = Get.put(AuthenticationController());
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => authenticationController.checkLogin());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getPageContent(child: Center(child: SpinKitFoldingCube(color: Colors.white, size: 50.0)));
  }
}
