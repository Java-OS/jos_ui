import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/system_controller.dart';

var _systemController = Get.put(SystemController());

Future<void> displayPowerModal() async {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey,width: 1),borderRadius: BorderRadius.circular(3)),
        contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        content: Container(
          color: Color.fromRGBO(13, 21, 13, 0.7),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: actionButton(Icons.autorenew_rounded, 'Reboot', Colors.redAccent, _systemController.systemReboot, false),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: actionButton(Icons.power_settings_new_outlined, 'Shutdown', Colors.redAccent, _systemController.systemShutdown, false),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

Widget actionButton(IconData icon, String tooltipMessage, Color hoverColor, Function action, bool rotateIcon) {
  return Tooltip(
    preferBelow: false,
    verticalOffset: 45,
    message: tooltipMessage,
    child: OutlinedButton(
      style: ButtonStyle(
        side: MaterialStateProperty.resolveWith<BorderSide>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return BorderSide(color: hoverColor);
            }
            return BorderSide(color: Colors.white38);
          },
        ),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return hoverColor; // Set the hover icon color
            }
            return Colors.white38; // Set the default icon color
          },
        ),
      ),
      onPressed: () => action(),
      // child: Icon(icon, size: 40),
      child: Icon(icon, size: 40),
    ),
  );
}
