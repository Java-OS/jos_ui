import 'package:flutter/material.dart';
import 'package:jos_ui/pages/top_menu.dart';

class WebLayout extends StatelessWidget {
  final Widget child;

  const WebLayout({Key? key, required this.child}) : super(key: key);

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
          color: Color.fromRGBO(0, 0, 0, 200),
          child: Padding(
            padding: const EdgeInsets.all(54.0),
            child: Column(
              children: [
                TopMenu(),
                Divider(color: Colors.white,),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: child,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
