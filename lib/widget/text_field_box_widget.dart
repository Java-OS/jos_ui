import 'package:flutter/material.dart';

class TextFieldBox extends StatefulWidget {
  final TextEditingController? controller;
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
  final bool? disableRadius;
  final EdgeInsets contentPadding;
  final double cursorHeight;
  final TextStyle textStyle;
  final TextStyle hintStyle;
  final Widget? prefixIcon;
  final double maxWidth;

  const TextFieldBox({
    super.key,
    this.controller,
    this.label,
    this.onSubmit,
    this.isPassword = false,
    this.isEnable = true,
    this.maxLines,
    this.maxLength,
    this.onClick,
    this.keyboardType,
    this.isExpanded,
    this.backgroundColor,
    this.disableRadius,
    this.contentPadding = const EdgeInsets.all(8),
    this.cursorHeight = 16,
    this.textStyle = const TextStyle(fontSize: 14, color: Colors.black),
    this.hintStyle = const TextStyle(fontSize: 12),
    this.prefixIcon,
    this.maxWidth = 25,
  });

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
                  style: widget.textStyle,
                  obscureText: widget.isPassword,
                  enableSuggestions: !widget.isPassword,
                  autocorrect: !widget.isPassword,
                  keyboardType: widget.keyboardType ?? TextInputType.text,
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.top,
                  textInputAction: TextInputAction.none,
                  maxLines: widget.isPassword ? 1 : widget.maxLines,
                  maxLength: widget.maxLength,
                  cursorHeight: widget.cursorHeight,
                  decoration: InputDecoration(
                    prefixIcon: widget.prefixIcon,
                    prefixIconConstraints: BoxConstraints(maxHeight: widget.maxWidth),
                    counterText: '',
                    label: Text(widget.label ?? '', style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.2, color: Colors.black), borderRadius: getBorderRadius()),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.2, color: Colors.blueAccent), borderRadius: getBorderRadius()),
                    border: OutlineInputBorder(borderRadius: getBorderRadius()),
                    hintStyle: widget.hintStyle,
                    isDense: true,
                    contentPadding: widget.contentPadding,
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
                onPressed: () => setState(() => clear()),
                icon: Icon(Icons.cancel_outlined, color: Colors.red, size: 14),
                splashRadius: 12,
              ),
            ),
          ),
        )
      ],
    );
  }

  BorderRadius getBorderRadius() => (widget.disableRadius == null || widget.disableRadius == false) ? BorderRadius.all(Radius.circular(3)) : BorderRadius.zero;

  void clear() {
    isClearButtonVisible = false;
    if (widget.controller != null) widget.controller!.text = '';
  }
}
