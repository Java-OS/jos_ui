import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/system_controller.dart';

class BasicComponent extends StatefulWidget {
  const BasicComponent({super.key});

  @override
  State<BasicComponent> createState() => _BasicComponentState();
}

class _BasicComponentState extends State<BasicComponent> {
  final SystemController systemController = Get.put(SystemController());

  @override
  void initState() {
    super.initState();
    systemController.fetchHostname();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          TextField(
            controller: systemController.hostnameEditingController,
            decoration: InputDecoration(
              label: Text('Hostname'),
            ),
            onSubmitted: (_) => systemController.changeHostname(),
          ),
          Align(alignment: Alignment.bottomRight, child: ElevatedButton(onPressed: () => systemController.changeHostname(), child: Text('Apply')))
        ],
      ),
    );
  }
}
