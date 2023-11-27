import 'package:flutter/material.dart';
import 'package:jos_ui/component/top_menu_component.dart';
import 'package:jos_ui/component/user_management_component.dart';
import 'package:jos_ui/page_base_content.dart';

class ModulePage extends StatefulWidget {
  const ModulePage({super.key});

  @override
  State<ModulePage> createState() => _ModulePageState();
}

class _ModulePageState extends State<ModulePage> {
  @override
  Widget build(BuildContext context) {
    return getPageContent(child: _pageContent());
  }

  Widget _pageContent() {
    return Center(
      child: SizedBox(
        width: 600,
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopMenuComponent(selectedIndex: 3),
            SizedBox(height: 8),
            Expanded(
              child: Container(
                width: double.infinity,
                color: Color.fromRGBO(236, 226, 226, 1.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Modules', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
                      Divider(),
                      UserManagementComponent()
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
