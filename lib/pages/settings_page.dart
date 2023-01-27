import 'package:flutter/material.dart';
import 'package:jos_ui/pages/top_menu.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/background.jpg"), fit: BoxFit.cover),
        ),
        child: Container(
          color: Color.fromRGBO(0, 0, 0, 80),
          child: Padding(
            padding: const EdgeInsets.all(54.0),
            child: Column(
              children: const [
                TopMenu(),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text('Settings Page'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
