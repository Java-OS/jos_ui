import 'package:flutter/material.dart';
import 'package:jos_ui/component/card_content.dart';

class DirectoryTreePage extends StatefulWidget {
  const DirectoryTreePage({super.key});

  @override
  State<DirectoryTreePage> createState() => _DirectoryTreePageState();
}

class _DirectoryTreePageState extends State<DirectoryTreePage> {
  @override
  Widget build(BuildContext context) {
    return CardContent(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Text('Hello'),
      ),
    );
  }
}
