import 'package:flutter/material.dart';
import 'package:jos_ui/top_menu.dart';

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
      home: Scaffold(
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background.jpg"), fit: BoxFit.cover),
          ),
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 80),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  TopMenu(),
                  Expanded(
                    child: GridView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          childAspectRatio: 5/2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8),
                      children: [
                        Container(
                          color: Colors.red,
                          child: Text("Hello"),
                        ),
                        Container(
                          // width: double.infinity,
                          // height: 100,
                          color: Colors.blue,
                          child: Text("Hello"),
                        ),
                        Container(
                          // width: double.infinity,
                          // height: 100,
                          color: Colors.green,
                          child: Text("Hello"),
                        ),
                      ],
                    ),
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
