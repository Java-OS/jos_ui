import 'package:flutter/material.dart';

class TileComponent extends StatefulWidget {
  final int index;
  final Widget title;
  final Widget? subTitle;
  final Widget? actions;
  const TileComponent({super.key, required this.index, required this.title, this.actions, this.subTitle});

  @override
  State<TileComponent> createState() => _TileComponentState();
}

class _TileComponentState extends State<TileComponent> {
  int hoverIndex = -1;

  @override
  Widget build(BuildContext context) {
    bool effectStatement = (hoverIndex == widget.index && widget.index != 0);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: MouseRegion(
        onHover: (_) => setState(() => hoverIndex = widget.index),
        onExit: (_) => setState(() => hoverIndex = -1),
        child: Material(
          elevation: effectStatement ? 2 : 0,
          shadowColor: Colors.black,
          borderRadius: BorderRadius.circular(5),
          child: AnimatedContainer(
            decoration: BoxDecoration(
              border: Border.all(
                  color: effectStatement
                      ? Colors.blue
                      : Colors.grey.shade400,
                  width: 0.5),
              borderRadius: BorderRadius.circular(5),
            ),
            duration: Duration(milliseconds: 500),
            child: ListTile(
              leading: widget.index == 0
                  ? null
                  : CircleAvatar(
                  radius: 12,
                  child: Text(widget.index.toString(),
                      style: TextStyle(fontSize: 12))),
              title: widget.title,
              subtitle: widget.subTitle ,
              trailing: widget.actions,
            ),
          ),
        ),
      ),
    );
  }
}
