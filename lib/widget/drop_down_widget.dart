import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DropDownMenu<T> extends StatefulWidget {
  final T? value;
  final Text? hint;
  final List<DropdownMenuItem<T>> items;
  final Function(dynamic) onChanged;
  final bool displayClearButton;
  final bool requiredValue;
  final bool disabled;
  final String? label;
  final TextStyle? labelStyle;
  final Function? onClear;
  final bool? disableRadius;

  const DropDownMenu({
    super.key,
    required this.value,
    this.hint,
    required this.items,
    required this.onChanged,
    this.displayClearButton = true,
    this.requiredValue = false,
    this.disabled = false,
    this.label,
    this.labelStyle,
    this.onClear,
    this.disableRadius,
  });

  @override
  State<DropDownMenu> createState() => _DropDownMenuState<T>();
}

class _DropDownMenuState<T> extends State<DropDownMenu<T>> {
  bool isClearButtonVisible = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        DropdownButtonFormField<T>(
          style: TextStyle(fontSize: 12),
          hint: widget.hint,
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: widget.labelStyle,
            hintStyle: TextStyle(fontSize: 12),
            isDense: true,
            contentPadding: EdgeInsets.all(8),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.2, color: Colors.black), borderRadius: getBorderRadius()),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.2, color: Colors.blueAccent), borderRadius: getBorderRadius()),
            border: OutlineInputBorder(borderRadius: getBorderRadius()),
          ),
          items: widget.disabled ? [] : widget.items,
          value: (widget.requiredValue || isClearButtonVisible) ? widget.value : null,
          onChanged: widget.disabled ? null : (value) => callOnChangeFunction(value),
        ),
        Visibility(
          visible: widget.displayClearButton ,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: IconButton(
                onPressed: () => callClearButton(),
                icon: Icon(MdiIcons.close, color: Colors.red, size: 14),
                splashRadius: 12,
              ),
            ),
          ),
        )
      ],
    );
  }

  BorderRadius getBorderRadius() => (widget.disableRadius == null || widget.disableRadius == false) ? BorderRadius.all(Radius.circular(3)) : BorderRadius.zero;

  void callOnChangeFunction(dynamic value) {
    setState(() => isClearButtonVisible = true);
    widget.onChanged(value);
  }

  void callClearButton() {
    setState(() => isClearButtonVisible = false);
    if (widget.onClear != null) widget.onClear!();
  }
}
