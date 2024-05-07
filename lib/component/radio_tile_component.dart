import 'package:flutter/material.dart';

class RadioTileComponent<T> extends StatefulWidget {
  final int index;
  final T value;
  final T? selectedValue;
  final Text title;
  final Widget? leading;
  final Widget? subTitle;
  final Function(dynamic value) onChanged;

  const RadioTileComponent({super.key, required this.index, required this.value, this.subTitle, this.leading, required this.onChanged, required this.title, this.selectedValue});

  @override
  State<RadioTileComponent> createState() => _RadioTileComponentState<T>();
}

class _RadioTileComponentState<T> extends State<RadioTileComponent> {
  int hoverIndex = -1;

  @override
  Widget build(BuildContext context) {
    bool effectStatement = (hoverIndex == widget.index);
    return MouseRegion(
      onHover: (_) => setState(() => hoverIndex = widget.index),
      onExit: (_) => setState(() => hoverIndex = -1),
      child: Material(
        elevation: effectStatement ? 2 : 0,
        shadowColor: Colors.black,
        borderRadius: BorderRadius.circular(5),
        child: AnimatedContainer(
          decoration: BoxDecoration(
            border: Border.all(color: effectStatement ? Colors.blue : Colors.grey.shade400, width: 0.5),
            borderRadius: BorderRadius.circular(5),
          ),
          duration: Duration(milliseconds: 500),
          child: RadioListTile<T>(
            mouseCursor: SystemMouseCursors.click,
            value: widget.value,
            title: widget.title,
            subtitle: widget.subTitle,
            onChanged: (T? value) => widget.onChanged(value),
            groupValue: widget.selectedValue,
          ),
        ),
      ),
    );
  }
}
