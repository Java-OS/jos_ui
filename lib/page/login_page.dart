import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:jos_ui/page_base_content.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return getPageContent(child: _pageContent());
  }

  Widget _pageContent() {
    return Center(
      child: SizedBox(
        width: 300,
        height: 230,
        child: Card(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white38), borderRadius: BorderRadius.zero),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
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

  void _login() {
    developer.log('Login called');
    Navigator.of(context).pushReplacementNamed('/home');
  }
}
