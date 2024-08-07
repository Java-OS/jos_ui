import 'package:flutter/material.dart';

class TextFieldBox extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final Function(String)? onSubmit;
  final bool isPassword;
  final bool? isEnable;
  final bool? isExpanded;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final Function? onClick;
  final Color? backgroundColor;
  final Color? color;
  final bool? removeRadius;

  const TextFieldBox({super.key, required this.controller, this.label, this.onSubmit, this.isPassword = false, this.isEnable = true, this.maxLines, this.maxLength, this.onClick, this.keyboardType, this.isExpanded, this.backgroundColor, this.color, this.removeRadius});

  @override
  State<TextFieldBox> createState() => _TextFieldBoxState();
}

class _TextFieldBoxState extends State<TextFieldBox> {
  bool isClearButtonVisible = false;
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        MouseRegion(
          onHover: (_) => setState(() => hovered = true),
          cursor: hovered ? SystemMouseCursors.click : SystemMouseCursors.basic,
          onExit: (_) => setState(() => hovered = false),
          child: InkWell(
            onTap: widget.onClick == null ? null : () => widget.onClick!(),
            child: IgnorePointer(
              ignoring: widget.onClick == null ? false : true,
              child: Material(
                elevation: hovered ? 3 : 0,
                shadowColor: Colors.black,
                child: TextField(
                  expands: widget.isExpanded ?? false,
                  enabled: widget.isEnable,
                  onSubmitted: (e) => widget.onSubmit!(e),
                  controller: widget.controller,
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.color ?? (widget.isEnable! ? Colors.black : Colors.black.withAlpha(150)),
                  ),
                  obscureText: widget.isPassword,
                  enableSuggestions: !widget.isPassword,
                  autocorrect: !widget.isPassword,
                  keyboardType: widget.keyboardType ?? TextInputType.text,
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.top,
                  textInputAction: TextInputAction.none,
                  maxLines: widget.isPassword ? 1 : widget.maxLines,
                  maxLength: widget.maxLength,
                  decoration: InputDecoration(
                    counterText: '',
                    label: Text(widget.label ?? ''),
                    border: OutlineInputBorder(borderRadius: (widget.removeRadius == null || widget.removeRadius == false) ? BorderRadius.all(Radius.circular(3)) : BorderRadius.zero),
                    hintStyle: TextStyle(fontSize: 12),
                    isDense: true,
                    contentPadding: EdgeInsets.all(14),
                    fillColor: widget.backgroundColor ?? Colors.white,
                    filled: true,
                  ),
                ),
              ),
            ),
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
