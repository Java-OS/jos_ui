import 'package:flutter/material.dart';

import 'WebLayout.dart';

class ModulesPage extends StatefulWidget {
  const ModulesPage({Key? key}) : super(key: key);

  @override
  State<ModulesPage> createState() => _ModulesPageState();
}

class _ModulesPageState extends State<ModulesPage> {
  @override
  Widget build(BuildContext context) {
    return WebLayout(child: Text('Modules Page'));
  }
}
