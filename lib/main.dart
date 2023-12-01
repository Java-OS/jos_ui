import 'package:flutter/material.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/service/route_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: false),
      debugShowCheckedModeBanner: false,
      title: 'JOS',
      initialRoute: '/',
      navigatorKey: navigatorKey,
      onGenerateRoute: RouteService.handle,
    );
  }
}
