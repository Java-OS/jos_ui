import 'package:flutter/material.dart';

class KeyValue extends StatefulWidget {
  final String k;
  final String v;
  final Color keyBackgroundColor;
  final Color valueBackgroundColor;
  final Color keyTextColor;
  final Color valueTextColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;

  const KeyValue({
    super.key,
    required this.k,
    required this.v,
    this.keyBackgroundColor = Colors.yellow,
    this.valueBackgroundColor = Colors.cyanAccent,
    this.borderColor = Colors.grey,
    this.borderWidth = 0.1,
    this.borderRadius = 4,
    this.keyTextColor = Colors.black,
    this.valueTextColor = Colors.black,
  });

  @override
  State<KeyValue> createState() => _KeyValueState();
}

class _KeyValueState extends State<KeyValue> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(left: 8, right: 8),
          decoration: BoxDecoration(
            color: widget.keyBackgroundColor,
            border: Border(
              top: BorderSide(width: widget.borderWidth, color: widget.borderColor),
              bottom: BorderSide(width: widget.borderWidth, color: widget.borderColor),
              left: BorderSide(width: widget.borderWidth, color: widget.borderColor),
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(widget.borderRadius),
              topLeft: Radius.circular(widget.borderRadius),
            ),
          ),
          child: Center(
            child: Text(
              widget.k,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: widget.keyTextColor,
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 8, right: 8),
          decoration: BoxDecoration(
            color: widget.valueBackgroundColor,
            border: Border(
              top: BorderSide(width: widget.borderWidth, color: widget.borderColor),
              bottom: BorderSide(width: widget.borderWidth, color: widget.borderColor),
              right: BorderSide(width: widget.borderWidth, color: widget.borderColor),
            ),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(widget.borderRadius),
              topRight: Radius.circular(widget.borderRadius),
            ),
          ),
          child: Text(
            widget.v,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: widget.valueTextColor,
            ),
          ),
        ),
      ],
    );
  }
}
