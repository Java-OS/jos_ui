import 'package:flutter/material.dart';

class CharButton extends StatelessWidget {
  final String char;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final VoidCallback? onPressed;
  final String? toolTip;

  const CharButton({
    super.key,
    required this.char,
    this.width = 20,
    this.height = 20,
    this.onPressed,
    this.toolTip,
    this.backgroundColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.zero,
        ),
        child: toolTip == null ? Text(char, style: textStyle) : getTextWithTooltip(),
      ),
    );
  }

  Widget getTextWithTooltip() {
    return Tooltip(
      message: toolTip,
      preferBelow: false,
      verticalOffset: 22,
      child: Text(char, style: textStyle),
    );
  }
}
