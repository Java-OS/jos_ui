import 'package:flutter/material.dart';

class TabContent extends StatefulWidget {
  final String title;
  final Widget? toolbar;
  final Widget content;

  const TabContent({super.key, required this.title, this.toolbar, required this.content});

  @override
  State<TabContent> createState() => _TabContentState();
}

class _TabContentState extends State<TabContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
            Flexible(child: widget.toolbar ?? SizedBox.shrink()),
          ],
        ),
        Divider(),
        Expanded(
          child: widget.content,
        )
      ],
    );
  }
}
