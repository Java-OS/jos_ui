import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/page/dashboard_page.dart';
import 'package:jos_ui/page/login_page.dart';
import 'package:jos_ui/page/module_page.dart';
import 'package:jos_ui/page/network/network_base_page.dart';
import 'package:jos_ui/page/settings/settings_base_page.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:toastification/toastification.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        theme: ThemeData(useMaterial3: false, fontFamily: 'Roboto'),
        debugShowCheckedModeBanner: false,
        title: 'JOS',
        initialRoute: '/',
        navigatorKey: navigatorKey,
        getPages: [
          GetPage(name: '/', page: () => LoginPage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
          GetPage(name: '/login', page: () => LoginPage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
          GetPage(name: '/dashboard', page: () => DashboardPage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
          GetPage(name: '/settings/:index', page: () => SettingsBasePage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
          GetPage(name: '/networks/:index', page: () => NetworkBasePage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
          GetPage(name: '/modules', page: () => ModulePage(), transition: Transition.fadeIn, transitionDuration: Duration(milliseconds: 300)),
        ],
      ),
    );
  }
}
