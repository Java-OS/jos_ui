import 'package:flutter/material.dart';

class TextLogo extends StatelessWidget {
  final Color? color;
  const TextLogo({Key? key, this.color = Colors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "JOS",
      style: TextStyle(
        color: color,
        fontSize: 44,
        fontWeight: FontWeight.bold,
        fontFamily: "akashi",
      ),
    );
  }
}
