import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/page_base_content.dart';
import 'package:jos_ui/service/rest_api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return getPageContent(child: _pageContent());
  }

  Widget _pageContent() {
    return Center(
      child: SizedBox(
        width: 300,
        height: 300,
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
                  controller: _usernameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.white38),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
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
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(onPressed: _login, child: Text('Login')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    developer.log('Login called');
    var username = _usernameController.text;
    var password = _passwordController.text;
    var success = await RestApiService.login(username, password);
    if (success) navigatorKey.currentState?.pushReplacementNamed('/home');
  }
}
