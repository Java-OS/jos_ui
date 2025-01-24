import 'package:flutter/material.dart';
import 'package:jos_ui/widget/check_box.dart';
import 'package:jos_ui/widget/drop_down_widget.dart';

class RuleDropDown<T> extends StatefulWidget {
  final String label;
  final bool active;
  final bool displayCheckBox;
  final bool isDropDown;

  final List<DropdownMenuItem<T>> dropDownItems;
  final Function(dynamic) onDropDownChange;
  final T dropDownValue;

  const RuleDropDown({
    super.key,
    required this.label,
    this.active = false,
    this.displayCheckBox = true,
    this.isDropDown = false,
    required this.onDropDownChange,
    required this.dropDownItems,
    required this.dropDownValue,
  });

  @override
  State<RuleDropDown> createState() => _RuleDropDownState<T>();
}

class _RuleDropDownState<T> extends State<RuleDropDown<T>> {
  var isActivated = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.active ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() => widget.active ? false : isActivated = !isActivated),
        child: Visibility(
          visible: widget.active || isActivated,
          replacement: label(widget.label),
          child: Row(
            spacing: 8,
            children: [
              label(widget.label),
              Visibility(
                visible: widget.displayCheckBox,
                child: CheckBox(
                  icon: Icon(
                    Icons.priority_high,
                    size: 16,
                  ),
                ),
              ),
              Expanded(
                child: Expanded(
                  child: DropDownMenu<T>(
                    disableRadius: true,
                    displayClearButton: false,
                    onChanged: (e) => widget.onDropDownChange(e),
                    value: widget.dropDownValue,
                    items: widget.dropDownItems,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget label(String label) {
    return Container(
      width: 100,
      padding: EdgeInsets.only(left: 4, right: 4),
      decoration: BoxDecoration(
        color: isActivated ? Colors.black12 : Colors.transparent,
        border: Border.fromBorderSide(
          BorderSide(width: 0.1, color: Colors.black),
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.right,
      ),
    );
  }
}
