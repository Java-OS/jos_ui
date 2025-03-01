import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/authentication_controller.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  final _authController = Get.put(AuthenticationController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _authController.checkToken());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Please wait ...', style: TextStyle(color: Colors.black, fontSize: 14)),
              LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
