import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/basic_controller.dart';

class BasicComponent extends StatefulWidget {
  const BasicComponent({super.key});

  @override
  State<BasicComponent> createState() => _BasicComponentState();
}

class _BasicComponentState extends State<BasicComponent> {
  final BasicController basicController = Get.put(BasicController());

  @override
  void initState() {
    super.initState();
    basicController.fetchHostname();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          TextField(
            controller: basicController.hostnameEditingController,
            decoration: InputDecoration(
              label: Text('Hostname'),
            ),
            onSubmitted: (_) => basicController.changeHostname(),
          ),
          Align(alignment: Alignment.bottomRight, child: ElevatedButton(onPressed: () => basicController.changeHostname(), child: Text('Apply')))
        ],
      ),
    );
  }
}
