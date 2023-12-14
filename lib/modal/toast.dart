import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jos_ui/constant.dart';

enum MessageType {
  info(Icons.info_outline_rounded, Colors.blue, 'Information'),
  warning(Icons.warning_amber_outlined, Colors.orange, 'Warning'),
  error(Icons.error_outline, Colors.red, 'Error'),
  success(Icons.check_circle_outline_outlined, Colors.green, 'Success');

  final MaterialColor color;
  final String title;
  final IconData icon;

  const MessageType(this.icon, this.color, this.title);
}

var fToast = FToast();

void _showMessage(String message, MessageType messageType, int timeout) {
  fToast.init(navigatorKey.currentState!.context);

  fToast.showToast(
    child: Container(
      color: Colors.white,
      constraints: BoxConstraints(minWidth: 300),
      height: 60,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 5, height: 60, color: messageType.color),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            child: Icon(messageType.icon, color: messageType.color),
          ),
          SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                messageType.title,
                style: TextStyle(color: messageType.color, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(message),
            ],
          )
        ],
      ),
    ),
    gravity: ToastGravity.TOP_RIGHT,
    toastDuration: Duration(seconds: timeout),
  );
}

void displayInfo(String message, {timeout}) => _showMessage(message, MessageType.info, timeout ?? 3);

void displayWarning(String message, {timeout}) => _showMessage(message, MessageType.warning, timeout ?? 3);

void displaySuccess(String message, {timeout}) => _showMessage(message, MessageType.success, timeout ?? 3);

void displayError(String message, {timeout}) => _showMessage(message, MessageType.error, timeout ?? 3);
