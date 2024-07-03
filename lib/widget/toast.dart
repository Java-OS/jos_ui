import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

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

void _showMessage(String message, MessageType messageType, int timeout) {
  toastification.show(
    type: ToastificationType.success,
    style: ToastificationStyle.minimal,
    autoCloseDuration: const Duration(seconds: 3),
    title: Text(messageType.title),
    description: Text(message),
    alignment: Alignment.topRight,
    direction: TextDirection.ltr,
    animationDuration: const Duration(milliseconds: 300),
    icon: Icon(messageType.icon, color: messageType.color),
    primaryColor: Colors.green,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.zero,
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      )
    ],
    showProgressBar: true,
    closeButtonShowType: CloseButtonShowType.onHover,
    closeOnClick: false,
    pauseOnHover: true,
    dragToClose: true,
  );
}

void displayInfo(String message, {timeout}) => _showMessage(message, MessageType.info, timeout ?? 3);

void displayWarning(String message, {timeout}) => _showMessage(message, MessageType.warning, timeout ?? 3);

void displaySuccess(String message, {timeout}) => _showMessage(message, MessageType.success, timeout ?? 3);

void displayError(String message, {timeout}) => _showMessage(message, MessageType.error, timeout ?? 3);
