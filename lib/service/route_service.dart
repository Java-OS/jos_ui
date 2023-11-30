import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:jos_ui/page/home_page.dart';
import 'package:jos_ui/page/login_page.dart';
import 'package:jos_ui/page/module_page.dart';
import 'package:jos_ui/page/setting_page.dart';
import 'package:jos_ui/page/user_page.dart';

class RouteService {
  static Route<dynamic> handle(RouteSettings settings) {
    var target = settings.name;
    developer.log('Route to $target with args ${settings.arguments}');
    switch (target) {
      case '/':
        return PageRouteBuilder(pageBuilder: (_, __, ___) => LoginPage());
      case '/home':
        return PageRouteBuilder(pageBuilder: (_, __, ___) => HomePage());
      case '/setting':
        var tabIndex = settings.arguments as int;
        return PageRouteBuilder(pageBuilder: (_, __, ___) => SettingPage(tabIndex: tabIndex));
      case '/user':
        return PageRouteBuilder(pageBuilder: (_, __, ___) => UserPage());
      case '/module':
        return PageRouteBuilder(pageBuilder: (_, __, ___) => ModulePage());
      default:
        return PageRouteBuilder(pageBuilder: (_, __, ___) => LoginPage());
    }
  }
}
