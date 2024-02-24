import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/page/dashboard_page.dart';
import 'package:jos_ui/page/login_page.dart';
import 'package:jos_ui/page/module_page.dart';
import 'package:jos_ui/page/network_page.dart';
import 'package:jos_ui/page/settings_page.dart';
import 'package:jos_ui/page/wait_page.dart';
import 'package:jos_ui/service/injection_provider.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  InjectionProvider.init();
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData.light(useMaterial3: false),
      debugShowCheckedModeBanner: false,
      title: 'JOS',
      initialRoute: '/',
      navigatorKey: navigatorKey,
      getPages: [
        GetPage(name: '/', page: () => LoginPage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
        GetPage(name: '/login', page: () => LoginPage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
        GetPage(name: '/dashboard', page: () => DashboardPage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
        GetPage(name: '/settings/:index', page: () => SettingsPage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
        GetPage(name: '/network/:index', page: () => NetworkPage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
        GetPage(name: '/modules', page: () => ModulePage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
      ],
    );
  }
}
