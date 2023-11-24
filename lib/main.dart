import 'package:flutter/material.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/service/RouteService.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JOS',
      initialRoute: '/',
      navigatorKey: navigatorKey,
      onGenerateRoute: RouteService.handle,
    );
  }
}
