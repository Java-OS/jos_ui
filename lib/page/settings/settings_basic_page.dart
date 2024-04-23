import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/settings_side_menu_component.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/system_controller.dart';
import 'package:jos_ui/dialog/system_dialog.dart';
import 'package:jos_ui/page_base_content.dart';
import 'package:jos_ui/widget/text_field_box_widget.dart';

class SettingsBasicPage extends StatefulWidget {
  const SettingsBasicPage({super.key});

  @override
  State<SettingsBasicPage> createState() => _SettingsBasicPageState();
}

class _SettingsBasicPageState extends State<SettingsBasicPage> {
  final SystemController _systemController = Get.put(SystemController());

  @override
  void initState() {
    _systemController.fetchHostname();
    _systemController.fetchDnsNameserver();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getPageContent(
      child: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsSideMenuComponent(),
            Expanded(
              child: Container(
                color: componentBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Basic Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
                      Divider(),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFieldBox(
                                isEnable: false,
                                isPassword: false,
                                label: 'Hostname',
                                controller: _systemController.hostnameEditingController,
                                onClick: () => displayHostnameModal(context),
                              ),
                              SizedBox(height: 16),
                              TextFieldBox(
                                isEnable: false,
                                isPassword: false,
                                label: 'DNS Nameserver (Max 3 ip, Comma delimited)',
                                controller: _systemController.dnsEditingController,
                                onClick: () => displayDNSNameserverModal(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Widget chooseTargetTab() {
//   var tabIndex = Get.parameters['index'] ?? '0';
//   switch (int.parse(tabIndex)) {
//     case 0:
//       return displayBasicSettings();
//     case 1:
//       return displayDateAndTimeContent();
//     case 2:
//       return displayEnvironmentsContent();
//     case 3:
//       return displayUserManagementContent();
//     case 4:
//       return displayFilesystemContent();
//     case 5:
//       return displayBackupSettings();
//     default:
//       return displayBasicSettings();
//   }
// }
//
// Widget displayBackupSettings() {
//   return basicContent(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         Text('Backup', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
//         Divider(),
//         BackupComponent(),
//       ],
//     ),
//   );
// }
//
// Widget displayDateAndTimeContent() {
//   return basicContent(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         Text('Date and Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
//         Divider(),
//         DateTimeComponent(),
//       ],
//     ),
//   );
// }
//
// Widget displayUserManagementContent() {
//   return basicContent(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         Text('Users', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
//         Divider(),
//         UserManagementComponent(),
//       ],
//     ),
//   );
// }
//
// Widget displayEnvironmentsContent() {
//   return basicContent(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         Text('Environment Variables', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
//         Divider(),
//         EnvironmentComponent(),
//       ],
//     ),
//   );
// }
//
// Widget displayFilesystemContent() {
//   return basicContent(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('Filesystem', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
//             /* Refresh component [NO NOT MOVE THIS TO FilesystemComponent]*/
//             OutlinedButton(onPressed: () => _systemController.fetchPartitions(), child: Icon(Icons.refresh_rounded, size: 16, color: Colors.black)),
//           ],
//         ),
//         Divider(),
//         FilesystemComponent(),
//       ],
//     ),
//   );
// }
}
