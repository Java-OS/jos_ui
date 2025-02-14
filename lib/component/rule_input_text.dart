import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jos_ui/component/text_field_box.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RuleInputText extends StatefulWidget {
  final TextEditingController? controller;

  final Function(bool isNot)? onNot;
  final Function()? onDeactivate;
  final Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final String label;
  final bool enable;
  final bool displayCheckBox;
  final bool displayCloseButton;
  final int? maxLength;
  final double maxWidth;

  const RuleInputText({
    super.key,
    this.controller,
    required this.label,
    this.displayCheckBox = true,
    this.displayCloseButton = true,
    this.maxLength,
    this.maxWidth = 128,
    this.enable = true,
    this.onNot,
    this.onDeactivate,
    this.validator,
    this.inputFormatters,
  });

  @override
  State<RuleInputText> createState() => _RuleInputTextState();
}

class _RuleInputTextState extends State<RuleInputText> {
  var isActivated = false;
  var hoverCloseBtn = false;
  var hoverNotBtn = false;
  var isNot = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: !widget.enable ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() => isActivated = !isActivated),
        child: Visibility(
          visible: (widget.enable && isActivated) || (widget.controller != null && widget.controller!.text.isNotEmpty),
          replacement: label(widget.label),
          child: Row(
            spacing: 8,
            children: [
              Expanded(
                child: TextFieldBox(
                  inputFormatters: widget.inputFormatters,
                  validator: widget.validator,
                  maxLength: widget.maxLength,
                  maxWidth: widget.maxWidth,
                  maxLines: 1,
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(visible: widget.displayCloseButton, child: closeButton()),
                      Visibility(visible: widget.displayCheckBox, child: notButton()),
                      SizedBox(width: 8),
                    ],
                  ),
                  label: widget.label,
                  contentPadding: EdgeInsets.all(6),
                  textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  cursorHeight: 16,
                  controller: widget.controller,
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
      child: GestureDetector(
        onTap: () => setState(() {
          isNot = false;
          isActivated = false;
          if (widget.onDeactivate != null) widget.onDeactivate!();
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
        onTap: () {
          setState(() => isNot = !isNot);
          if (widget.onNot != null) widget.onNot!(isNot);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(right: BorderSide(width: 0.2, color: Colors.black)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: Icon(
              Icons.priority_high_rounded,
              color: isNot ? Colors.black : Colors.black26,
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
}
