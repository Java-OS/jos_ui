import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jos_ui/controller/authentication_controller.dart';
import 'package:jos_ui/page_base_content.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthenticationController authenticationController = Get.put(AuthenticationController());

  @override
  void initState() {
    authenticationController.requestPublicKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getPageContent(
      child: Center(
        child: SizedBox(
          width: 280,
          height: 400,
          child: Card(
            color: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white38), borderRadius: BorderRadius.zero),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  Center(child: Text('JOS', style: GoogleFonts.smoochSans(letterSpacing: 3, color: Colors.white, fontSize: 55, fontWeight: FontWeight.bold))),
                  TextField(
                    controller: authenticationController.usernameEditingController,
                    enableSuggestions: false,
                    autocorrect: false,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Colors.white38, fontSize: 12),
                      contentPadding: EdgeInsets.all(14),
                    ),
                    onSubmitted: (_) => authenticationController.login(),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: authenticationController.passwordEditingController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white38, fontSize: 12),
                      contentPadding: EdgeInsets.all(14),
                    ),
                    onSubmitted: (_) => authenticationController.login(),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: Row(
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
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: OutlinedButton(onPressed: () => authenticationController.requestPublicKey(), child: Icon(Icons.refresh, size: 16, color: Colors.blue)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: authenticationController.captchaEditingController,
                    enableSuggestions: false,
                    autocorrect: false,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
                      labelText: 'Captcha',
                      labelStyle: TextStyle(color: Colors.white38, fontSize: 12),
                      contentPadding: EdgeInsets.all(14),
                    ),
                    onSubmitted: (_) => authenticationController.login(),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(onPressed: () => authenticationController.login(), child: Text('Login')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget captchaWidget() {
    return Visibility(
      visible: authenticationController.captchaImage.value != null,
      replacement: SizedBox(width: 16, height: 16, child: CircularProgressIndicator()),
      child: ClipRRect(borderRadius: BorderRadius.circular(3), child: authenticationController.captchaImage.value),
    );
  }
}
