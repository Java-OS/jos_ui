import 'package:flutter/material.dart';
import 'package:jos_ui/RouteHandler.dart';


void main() {
  runApp(BaseApplication());
}

class BaseApplication extends StatelessWidget {
  const BaseApplication({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "JOS",
      initialRoute: '/',
      onGenerateRoute: RouteHandler.handle,
    );
  }
}
