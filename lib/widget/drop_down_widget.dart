import 'package:flutter/material.dart';

class DropDownMenu<T> extends StatefulWidget {
  final T? value;
  final Text hint;
  final List<DropdownMenuItem<T>> items;
  final Function(dynamic) onChanged;

  const DropDownMenu({super.key, required this.value, required this.hint, required this.items, required this.onChanged});

  @override
  State<DropDownMenu> createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  bool isClearButtonVisible = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        DropdownButtonFormField(
          style: TextStyle(fontSize: 14),
          hint: widget.hint,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintStyle: TextStyle(fontSize: 12),
            isDense: true,
            contentPadding: EdgeInsets.all(12),
          ),
          items: widget.items,
          value: isClearButtonVisible ? widget.value : null,
          onChanged: (value) => callOnChangeFunction(value),
        ),
        Visibility(
          visible: isClearButtonVisible,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: IconButton(
                onPressed: () => setState(() => isClearButtonVisible = false),
                icon: Icon(Icons.cancel_outlined, color: Colors.red, size: 14),
                splashRadius: 12,
              ),
            ),
          ),
        )
      ],
    );
  }

  void callOnChangeFunction(dynamic value) {
    setState(() => isClearButtonVisible = true);
    widget.onChanged(value);
  }
}
