import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/controller/event_controller.dart';
import 'package:jos_ui/controller/global/sse_controller.dart';
import 'package:jos_ui/message_buffer.dart';

var _eventController = Get.put(EventController());
var _sseController = Get.put(SSEController());

Future<void> displayEvent() async {
  _sseController.consumeEvents();
  showDialog(
    // barrierDismissible: false,
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(3)),
        contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        content: SizedBox(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isEventEmpty() ? 'Please wait ...' : _eventController.listEvents.last.message!, style: TextStyle(fontSize: 12, color: Colors.white)),
                  LinearProgressIndicator(color: Colors.lightGreenAccent, value: isEventEmpty() ? null : _eventController.listEvents.last.percentage),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.grey)),
                      child: Text(isEventEmpty() ? 'Close' : _eventController.listEvents.last.eventStatus == EventStatus.PROGRESS ? 'Run in background' : 'Close',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  ).then((_) => _sseController.disconnectSse());
}

bool isEventEmpty() {
  return _eventController.listEvents.isEmpty;
}
