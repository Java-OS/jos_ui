import 'package:flutter/material.dart';

class TextBox extends StatefulWidget {
  final TextEditingController controller;
  final String? label;

  const TextBox({super.key, required this.controller, this.label});

  @override
  State<TextBox> createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  bool isClearButtonVisible = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        TextField(
          controller: widget.controller,
          style: TextStyle(fontSize: 14),
          maxLines: 1,
          decoration: InputDecoration(
            label: Text(widget.label ?? ''),
            border: OutlineInputBorder(),
            hintStyle: TextStyle(fontSize: 12),
            isDense: true,
            contentPadding: EdgeInsets.all(14),
          ),
        ),
        Visibility(
          visible: isClearButtonVisible,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: IconButton(
                onPressed: () => {setState(() => clear())},
                icon: Icon(Icons.cancel_outlined, color: Colors.red, size: 14),
                splashRadius: 12,
              ),
            ),
          ),
        )
      ],
    );
  }

  void clear() {
    isClearButtonVisible = false;
    widget.controller.text = '';
  }
}
