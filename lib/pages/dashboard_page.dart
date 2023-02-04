import 'package:flutter/material.dart';
import 'package:jos_ui/pages/WebLayout.dart';
import 'package:jos_ui/service/ApiService.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return WebLayout(
      child: GridView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 500,
            childAspectRatio: 5 / 2,
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
    );

  }
}
