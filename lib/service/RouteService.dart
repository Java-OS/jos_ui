import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:jos_ui/page/home_page.dart';
import 'package:jos_ui/page/login_page.dart';

class RouteService {
  static Route<dynamic> handle(RouteSettings settings) {
    var target = settings.name;
    developer.log('Route to $target');
    switch (target) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomePage());
      default:
        return MaterialPageRoute(builder: (_) => LoginPage());
    }
  }
}
