import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          closeButton(),
        ],
      ),
    ),
  );
}

Widget getModalHeaderAdvanced({required String title, required List<Widget> actionButtons}) {
  actionButtons.add(closeButton());
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: actionButtons,
          ),
        ],
      ),
    ),
  );
}

Widget closeButton() => IconButton(
      onPressed: () => Get.back(),
      padding: EdgeInsets.zero,
      splashRadius: 10,
      icon: Icon(Icons.close, size: 22, color: Colors.white),
    );
