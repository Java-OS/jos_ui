import 'package:flutter/material.dart';
import 'package:jos_ui/constant.dart';

Future<bool> displayAlertModal(String title, String message, BuildContext context) async {
  var result = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: getModalHeader(title),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        contentPadding: EdgeInsets.all(14),
        titlePadding: EdgeInsets.zero,
        content: Text(message),
        actions: [
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text('Okay')),
          ElevatedButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
        ],
      );
    },
  );
  return result ?? false;
}
