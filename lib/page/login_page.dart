import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/authentication_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authenticationController = Get.put(AuthenticationController());

  @override
  void initState() {
    _authenticationController.requestPublicKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: Colors.white10, width: 1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(70.0),
                      child: Image.asset('assets/images/jos-logo.png'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0, left: 80.0),
                      child: Text(
                        'JVM/Linux operating system',
                        style: TextStyle(fontSize: 40, fontFamily: 'smooch', fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.only(left: 80.0),
                      child: Text('⬤   Open Source Software Under GPL v2'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 80.0),
                      child: Text('⬤   Easy to use'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 80.0),
                      child: Text('⬤   Fast and Secure'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 80.0),
                      child: Text('⬤   Modular'),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: 290,
              color: Colors.lightBlue,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _authenticationController.usernameEditingController,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white70,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        labelText: 'Username',
                        labelStyle: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      onSubmitted: (_) => _authenticationController.login(),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _authenticationController.passwordEditingController,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white70,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      onSubmitted: (_) => _authenticationController.login(),
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [Obx(() => captchaWidget())],
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(padding: EdgeInsets.zero, side: BorderSide(color: Colors.white30)),
                            onPressed: () => _authenticationController.requestPublicKey(),
                            child: Icon(Icons.refresh, size: 28, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _authenticationController.captchaEditingController,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white70,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        labelText: 'Captcha',
                        labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      onSubmitted: (_) => _authenticationController.login(),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                        onPressed: () => _authenticationController.login(),
                        child: Text('Login', style: TextStyle(color: Colors.blue, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget captchaWidget() {
    return Visibility(
      visible: _authenticationController.captchaImage.value != null,
      replacement: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white)),
      child: ClipRRect(borderRadius: BorderRadius.circular(3), child: _authenticationController.captchaImage.value),
    );
  }
}
