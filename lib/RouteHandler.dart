import 'package:flutter/material.dart';
import 'package:jos_ui/pages/dashboard_page.dart';
import 'package:jos_ui/pages/login_page.dart';
import 'package:jos_ui/pages/modules_page.dart';
import 'package:jos_ui/pages/settings_page.dart';

class RouteHandler {

  static Route<dynamic> handle(RouteSettings settings) {
    switch (settings.name) {
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
}
