import 'package:flutter/material.dart';
import 'package:jos_ui/top_menu.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

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
              children: [
                TopMenu(),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: GridView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 500,
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
    );
  }
}
