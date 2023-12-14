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
  Widget build(BuildContext context) {
    return getPageContent(
      child: Center(
        child: SizedBox(
          width: 310,
          height: 310,
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
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Colors.white38),
                    ),
                    onSubmitted: (_) => authenticationController.login(),
                  ),
                  SizedBox(height: 20),
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
                      labelStyle: TextStyle(color: Colors.white38),
                    ),
                    onSubmitted: (_) => authenticationController.login(),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(onPressed: () => authenticationController.login(_usernameEditingController.text, _passwordEditingController.text), child: Text('Login')),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
