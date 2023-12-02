import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

/// Colors
const componentBackgroundColor = Color.fromRGBO(236, 226, 226, 1.0);
const dashboardMosaicBackgroundColor = Color.fromRGBO(116, 211, 127, 0.5019607843137255);
const dashboardMosaicTextColor = Colors.white;
const dashboardMosaicTitleStyle = TextStyle(fontWeight: FontWeight.bold, color: dashboardMosaicTextColor, fontSize: 12);
const dashboardMosaicTextStyle = TextStyle(color: dashboardMosaicTextColor, fontSize: 12);

Widget getModalHeader(String title) {
  return Container(
    width: double.infinity,
    height: 46,
    color: Colors.green,
    child: Padding(
      padding: const EdgeInsets.all(14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
          IconButton(onPressed: () => _closeDialog(), padding: EdgeInsets.zero, splashRadius: 10, icon: Icon(Icons.close, size: 22, color: Colors.white))
        ],
      ),
    ),
  );
}

void _closeDialog() {
  navigatorKey.currentState?.pop();
}
