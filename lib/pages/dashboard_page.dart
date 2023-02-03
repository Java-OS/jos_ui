import 'package:flutter/material.dart';
import 'package:jos_ui/pages/WebLayout.dart';
import 'package:jos_ui/service/ApiService.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ApiService(context).rpc(300).then((value) => print(value));
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
