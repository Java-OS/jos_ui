import 'package:flutter/material.dart';
import 'package:jos_ui/widget/text_field_box_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RuleInputText extends StatefulWidget {
  final String label;
  final bool active;
  final bool displayCheckBox;
  final bool displayCloseButton;
  final int? maxLength;
  final double maxWidth;

  const RuleInputText({
    super.key,
    required this.label,
    this.active = false,
    this.displayCheckBox = true,
    this.displayCloseButton = true,
    this.maxLength,
    this.maxWidth = 256,
  });

  @override
  State<RuleInputText> createState() => _RuleInputTextState();
}

class _RuleInputTextState extends State<RuleInputText> {
  var controller = TextEditingController();
  var isActivated = false;
  var hoverCloseBtn = false;
  var hoverNotBtn = false;
  var isNot = false;

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
              Expanded(
                child: TextFieldBox(
                  maxLength: widget.maxLength,
                  maxWidth: widget.maxWidth,
                  maxLines: 1,
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(visible:widget.displayCloseButton ,child: closeButton()),
                      Visibility(visible:widget.displayCheckBox, child: notButton()),
                      SizedBox(width: 8),
                    ],
                  ),
                  label: widget.label,
                  contentPadding: EdgeInsets.all(6),
                  textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  cursorHeight: 16,
                  controller: controller,
                  disableRadius: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget closeButton() {
    return MouseRegion(
      cursor: hoverCloseBtn ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onHover: (e) => setState(() => hoverCloseBtn = true),
      onExit: (e) => setState(() => hoverCloseBtn = false),
      child: GestureDetector(
        onTap: () => setState(() {
          isNot = false;
          isActivated = false;
        }),
        child: Container(
          decoration: BoxDecoration(
            border: Border(right: BorderSide(width: 0.2, color: Colors.black)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: Icon(
              MdiIcons.close,
              color: Colors.redAccent,
            ),
          ),
        ),
      ),
    );
  }

  Widget notButton() {
    return MouseRegion(
      cursor: hoverNotBtn ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onHover: (e) => setState(() => hoverNotBtn = true),
      onExit: (e) => setState(() => hoverNotBtn = false),
      child: GestureDetector(
        onTap: () => setState(() => isNot = !isNot),
        child: Container(
          decoration: BoxDecoration(
            border: Border(right: BorderSide(width: 0.2, color: Colors.black)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: Icon(
              Icons.priority_high_rounded,
              color: (isNot || hoverNotBtn) ? Colors.black : Colors.black26,
            ),
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
          BorderSide(width: 0.1, color: Colors.black),
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
      ),
    );
  }
}
