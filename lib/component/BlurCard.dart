import 'dart:ui';

import 'package:flutter/material.dart';

class BlurCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double? padding;
  final Color color;

  final Border? border;

  const BlurCard(
      {Key? key,
      required this.child,
      this.width,
      this.height,
      this.padding,
      this.color = const Color.fromRGBO(255, 255, 255, 210),
      this.border})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
        child: Container(
          padding: padding != null ? EdgeInsets.all(padding!) : EdgeInsets.zero,
          decoration: BoxDecoration(
            border: border,
            color: color,
          ),
          height: height,
          width: width,
          child: child,
        ),
      ),
    );
  }
}
