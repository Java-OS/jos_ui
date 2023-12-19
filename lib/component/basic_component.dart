import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/system_controller.dart';
import 'package:jos_ui/widget/text_box_widget.dart';

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
          TextBox(
            isPassword: false,
            controller: systemController.hostnameEditingController,
            label: 'Hostname',
            onSubmit: (_) => systemController.changeHostname(),
          ),
          Align(alignment: Alignment.bottomRight, child: ElevatedButton(onPressed: () => systemController.changeHostname(), child: Text('Apply')))
        ],
      ),
    );
  }
}
