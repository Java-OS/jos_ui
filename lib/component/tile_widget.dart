import 'package:flutter/material.dart';

class TileItem extends StatefulWidget {
  final int index;
  final Widget title;
  final Widget? leading;
  final Widget? subTitle;
  final Widget? actions;
  final Function? onClick;

  const TileItem({super.key, required this.index, required this.title, this.actions, this.subTitle, this.leading, this.onClick});

  @override
  State<TileItem> createState() => _TileItemState();
}

class _TileItemState extends State<TileItem> {
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
          child: ListTile(
            mouseCursor: widget.onClick != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
            onTap: widget.onClick == null ? null : () => widget.onClick!(),
            leading: widget.leading,
            title: widget.title,
            subtitle: widget.subTitle,
            trailing: widget.actions,
          ),
        ),
      ),
    );
  }
}
