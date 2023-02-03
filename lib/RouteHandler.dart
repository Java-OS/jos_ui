import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jos_ui/pages/dashboard_page.dart';
import 'package:jos_ui/pages/login_page.dart';
import 'package:jos_ui/pages/modules_page.dart';
import 'package:jos_ui/pages/settings_page.dart';

class RouteHandler {
  static final storage = FlutterSecureStorage();


  static Route<dynamic> handle(RouteSettings settings) {
    return gotoTarget(settings.name);
  }

  static PageRouteBuilder<dynamic> gotoTarget(String? target) {
    switch (target) {
      case '/':
        return PageRouteBuilder(pageBuilder: (_, __, ___) => DashboardPage());
      case '/modules':
        return PageRouteBuilder(pageBuilder: (_, __, ___) => ModulesPage());
      case '/settings':
        return PageRouteBuilder(pageBuilder: (_, __, ___) => SettingsPage());
      case '/login':
        return PageRouteBuilder(pageBuilder: (_, __, ___) => LoginPage());
      default:
        return PageRouteBuilder(pageBuilder: (_, __, ___) => DashboardPage());
    }
  }

  static Future<bool> isLogin() async {
    var token = await storage.read(key: 'token');
    return token != null;
  }
}
