import 'package:flutter/material.dart';
import 'package:jos_ui/constant.dart';
import 'package:toastification/toastification.dart';
import 'package:toastification/src/widget/built_in/built_in_builder.dart';

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

ToastificationItem _showToast({
  AlignmentGeometry? alignment,
  Duration? autoCloseDuration,
  ToastificationAnimationBuilder? animationBuilder,
  ToastificationType? type,
  ToastificationStyle? style,
  required String title,
  Duration? animationDuration,
  String? description,
  Widget? icon,
  Color? primaryColor,
  Color? backgroundColor,
  Color? foregroundColor,
  EdgeInsetsGeometry? padding,
  EdgeInsetsGeometry? margin,
  BorderRadiusGeometry? borderRadius,
  List<BoxShadow>? boxShadow,
  TextDirection? direction,
  bool? showProgressBar,
  ProgressIndicatorThemeData? progressBarTheme,
  CloseButtonShowType? closeButtonShowType,
  bool? closeOnClick,
  bool? dragToClose,
  bool? pauseOnHover,
  ToastificationCallbacks callbacks = const ToastificationCallbacks(),
}) {
  return toastification.showWithNavigatorState(
    navigator: navigatorKey.currentState!,
    alignment: alignment,
    autoCloseDuration: autoCloseDuration,
    animationBuilder: animationBuilder,
    animationDuration: animationDuration,
    callbacks: callbacks,
    builder: (context, holder) {
      return BuiltInBuilder(
        item: holder,
        type: type,
        style: style,
        title: Text(title),
        description: Text(description ?? ''),
        icon: icon,
        primaryColor: primaryColor,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: padding,
        margin: margin,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        direction: direction,
        showProgressBar: showProgressBar,
        progressBarTheme: progressBarTheme,
        closeButtonShowType: closeButtonShowType,
        closeOnClick: closeOnClick,
        dragToClose: dragToClose,
        pauseOnHover: pauseOnHover,
        callbacks: callbacks,
      );
    },
  );
}

void _showMessage(String message, MessageType messageType, int timeout) {
  _showToast(
    type: ToastificationType.success,
    style: ToastificationStyle.minimal,
    autoCloseDuration: const Duration(seconds: 3),
    title: messageType.title,
    description: message,
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
