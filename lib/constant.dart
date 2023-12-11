import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

/// Colors
const componentBackgroundColor = Color.fromRGBO(236, 226, 226, 1.0);
const dashboardMosaicBackgroundColor = Color.fromRGBO(80, 100, 80, 0.5);

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
          IconButton(onPressed: () => navigatorKey.currentState?.pop(), padding: EdgeInsets.zero, splashRadius: 10, icon: Icon(Icons.close, size: 22, color: Colors.white))
        ],
      ),
    ),
  );
}

String truncateWithEllipsis(int length, String myString) {
  return (myString.length <= length) ? myString : '${myString.substring(0, length)}...';
}
