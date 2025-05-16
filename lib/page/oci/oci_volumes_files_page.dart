import 'package:flutter/material.dart';
import 'package:jos_ui/component/directory_tree.dart';

class OciVolumesFilesPage extends StatefulWidget {
  const OciVolumesFilesPage({super.key});

  @override
  State<OciVolumesFilesPage> createState() => _OciImagesPageState();
}

class _OciImagesPageState extends State<OciVolumesFilesPage> {
  @override
  Widget build(BuildContext context) {
    return DirectoryTree();
  }
}
