import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/page_base_content.dart';
import 'package:jos_ui/service/rest_api_service.dart';
import 'package:jos_ui/service/storage_service.dart';

class WaitPage extends StatefulWidget {
  const WaitPage({super.key});

  @override
  State<WaitPage> createState() => _WaitPageState();
}

class _WaitPageState extends State<WaitPage> {
  @override
  Widget build(BuildContext context) {
    return getPageContent(child: _pageContent());
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkLogin());
    super.initState();
  }

  Widget _pageContent() {
    return Center(
      child: SpinKitFoldingCube(
        color: Colors.white,
        size: 50.0,
      ),
    );
  }

  void _checkLogin() async {
    developer.log('Check Login called');
    var item = StorageService.getItem('token');
    if (item != null) {
      var isLogin = await RestClient.checkLogin();
      if (isLogin) {
        navigatorKey.currentState?.pushReplacementNamed('/home');
      } else {
        _gotoLoginPage();
      }
    } else {
      _gotoLoginPage();
    }
  }

  void _gotoLoginPage() {
    StorageService.removeItem('token');
    navigatorKey.currentState?.pushReplacementNamed('/login');
  }
}
