import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/system_controller.dart';
import 'package:jos_ui/model/module.dart';
import 'package:jos_ui/util/utils.dart';

Future<void> displayModuleInformationModal(Module module) async {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey, width: 1)),
        contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        content: Container(
          color: Color.fromRGBO(13, 21, 13, 0.7),
          padding: EdgeInsets.all(12),
          child: Obx(
            () => Table(
              columnWidths: {
                0: FixedColumnWidth(100),
                1: FixedColumnWidth(300),
              },
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Text('Name', style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.end),
                    ),
                    Text(module.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12)),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Text('Path', style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.end),
                    ),
                    Text(module.path, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12)),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Text('Maintainer', style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.end),
                    ),
                    Text(module.maintainer ?? '', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12)),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Text('Url', style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.end),
                    ),
                    Text(module.url ?? '', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12)),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Text('Description', style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.end),
                    ),
                    Text(module.description ?? '', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
