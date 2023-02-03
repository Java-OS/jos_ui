import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jos_ui/RouteHandler.dart';

String? token;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = FlutterSecureStorage();
  token = await storage.read(key: 'token');
  runApp(BaseApplication());
}

class BaseApplication extends StatelessWidget {
  const BaseApplication({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      title: "JOS",
      initialRoute: token == null ? "/login" : "/",
      onGenerateRoute: RouteHandler.handle ,
    );
  }
}
