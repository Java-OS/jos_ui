import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/authentication_controller.dart';
import 'package:jos_ui/controller/system_controller.dart';
import 'package:jos_ui/utils.dart';

var _systemController = Get.put(SystemController());

Future<void> displayInformationModal() async {
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
                      child: Text('Date & Time', style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.end),
                    ),
                    Text(_systemController.dateTimeZone.value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12)),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Text('Username', style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.end),
                    ),
                    Text(_systemController.osUsername.value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12)),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Text('Hostname', style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.end),
                    ),
                    Text(_systemController.osHostname.value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12)),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Text('Version', style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.end),
                    ),
                    Text(_systemController.osVersion.value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12)),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Text('Code Name', style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.end),
                    ),
                    Text(_systemController.osCodeName.value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12)),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Text('Java Vendor', style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.end),
                    ),
                    Text(_systemController.jvmVendor.value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12)),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Text('Java Version', style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.end),
                    ),
                    Text(_systemController.jvmVersion.value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12)),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Text('CPU Model', style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.end),
                    ),
                    Text(_systemController.hwCpuInfo.value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12)),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Text('CPU Cores', style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.end),
                    ),
                    Text(_systemController.hwCpuCount.value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12)),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Text('Total Memory', style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.end),
                    ),
                    Text(formatSize(_systemController.hwTotalMemory.value), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12)),
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
