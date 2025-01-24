import 'package:flutter/material.dart';

class CheckBox extends StatefulWidget {
  final Icon icon;
  final double width;
  final double height;

  const CheckBox({
    super.key,
    this.icon = const Icon(Icons.check, size: 20),
    this.width = 25,
    this.height = 25,
  });

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  var controller = TextEditingController();
  var isChecked = false;
  var hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (_) => setState(() => hovered = !hovered),
      child: GestureDetector(
        onTap: () => setState(() => isChecked = !isChecked),
        child: Material(
          elevation: hovered ? 3 : 0,
          shadowColor: Colors.black,
          child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                border: Border.all(width: 0.2, color: Colors.black),
                borderRadius: BorderRadius.zero,
              ),
              child: isChecked ? widget.icon : null),
        ),
      ),
    );
  }
}
