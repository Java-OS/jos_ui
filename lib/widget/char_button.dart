import 'package:flutter/material.dart';

class CharButton extends StatelessWidget {
  final String char;
  final Color? color;
  final double? size;
  final double? fontSize;
  final FontWeight? fontWeight;
  final VoidCallback? onPressed;
  final String? toolTip;

  const CharButton({super.key,
    required this.char,
    this.color = Colors.black,
    this.size = 20,
    this.fontSize = 11,
    this.fontWeight = FontWeight.normal,
    this.onPressed,
    this.toolTip});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: toolTip == null ? getText() : getTextWithTooltip(),
      ),
    );
  }

  Widget getText() {
    return Text(char,
        style: TextStyle(
            fontWeight: fontWeight, fontSize: fontSize, color: color));
  }

  Widget getTextWithTooltip() {
    return Tooltip(
      message: toolTip,
      preferBelow: false,
      verticalOffset: 22,
      child: getText(),
    );
  }
}
