import 'package:flutter/material.dart';
import 'package:jos_ui/constant.dart';

Future<void> displayAddUpdateEnvironmentModal(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: getModalHeader('Environment'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(decoration: InputDecoration(label: Text('Key'), hintStyle: TextStyle(fontSize: 12))),
              TextField(decoration: InputDecoration(label: Text('Value'), hintStyle: TextStyle(fontSize: 12))),
              SizedBox(height: 20),
              Align(alignment: Alignment.centerRight,child: ElevatedButton(onPressed: () {}, child: Text('Apply')))
            ],
          )
        ],
      );
    },
  );
}
