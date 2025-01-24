import 'package:flutter/material.dart';
import 'package:jos_ui/widget/check_box.dart';
import 'package:jos_ui/widget/text_field_box_widget.dart';

class RuleInputText extends StatefulWidget {
  final String label;
  final bool active;
  final bool displayCheckBox;

  const RuleInputText({
    super.key,
    required this.label,
    this.active = false,
    this.displayCheckBox = true,
  });

  @override
  State<RuleInputText> createState() => _RuleInputTextState();
}

class _RuleInputTextState extends State<RuleInputText> {
  var controller = TextEditingController();
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
                child: SizedBox(
                  child: TextFieldBox(
                    contentPadding: EdgeInsets.all(6),
                    textStyle: TextStyle(fontSize: 12),
                    cursorHeight: 16,
                    controller: controller,
                    disableRadius: true,
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
