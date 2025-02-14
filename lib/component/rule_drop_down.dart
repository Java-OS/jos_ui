import 'package:flutter/material.dart';
import 'package:jos_ui/component/drop_down.dart';

class RuleDropDown<T> extends StatefulWidget {
  final String label;
  final bool active;
  final bool displayClearButton;
  final bool enable;
  final bool required;

  final List<DropdownMenuItem<T>> dropDownItems;
  final Function(dynamic) onDropDownChange;
  final Function? onClear;
  final T dropDownValue;

  const RuleDropDown({
    super.key,
    required this.label,
    this.active = false,
    this.displayClearButton = false,
    required this.onDropDownChange,
    required this.dropDownItems,
    required this.dropDownValue,
    this.onClear,
    this.enable = true,
    this.required = false,
  });

  @override
  State<RuleDropDown> createState() => _RuleDropDownState<T>();
}

class _RuleDropDownState<T> extends State<RuleDropDown<T>> {
  var isActivated = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: !widget.enable ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.enable ? setState(() => isActivated = !isActivated) : null,
        child: Visibility(
          visible: widget.active || isActivated,
          replacement: label(widget.label),
          child: DropDownMenu<T>(
            requiredValue: widget.required,
            disableRadius: true,
            displayClearButton: widget.displayClearButton,
            label: widget.label,
            labelStyle: TextStyle(fontSize: 14, color: Colors.black),
            onClear: () => callOnClearButton(),
            onChanged: (e) => widget.onDropDownChange(e),
            value: widget.dropDownValue,
            items: widget.dropDownItems,
          ),
        ),
      ),
    );
  }

  Widget label(String label) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 4, right: 4),
      decoration: BoxDecoration(
        color: isActivated ? Colors.black12 : Colors.transparent,
        border: Border.fromBorderSide(
          BorderSide(width: 0.1, color: widget.enable ? Colors.black : Colors.grey),
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(color: widget.enable ? Colors.black : Colors.grey),
      ),
    );
  }

  void callOnClearButton() {
    setState(() => isActivated = false);
    if (widget.onClear != null) widget.onClear!();
  }
}
