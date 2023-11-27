import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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