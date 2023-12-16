import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jos_ui/component/top_menu_component.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/controller/jvm_controller.dart';
import 'package:jos_ui/controller/system_controller.dart';
import 'package:jos_ui/page_base_content.dart';
import 'package:jos_ui/utils.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(duration: Duration(seconds: 2), vsync: this)..repeat();
  final SystemController systemController = Get.put(SystemController());
  final JvmController jvmController = Get.put(JvmController());

  bool _mouseHoverOnBasicBox = false;
  bool _mouseHoverOnJVMBox = false;
  bool _mouseHoverOnActionBox = false;
  bool _mouseHoverOnHWBox = false;

  @override
  void initState() {
    super.initState();
    systemController.fetchSystemInformation();
  }

  @override
  Widget build(BuildContext context) {
    return getPageContent(
      child: Center(
        child: SizedBox(
          width: 600,
          height: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [TopMenuComponent(), SizedBox(height: 8), Obx(() => mosaicView())],
          ),
        ),
      ),
    );
  }

  Widget mosaicView() {
    return StaggeredGrid.count(
      crossAxisCount: 8,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: [
        StaggeredGridTile.count(crossAxisCellCount: 3, mainAxisCellCount: 3, child: displayBasicInformation()),
        StaggeredGridTile.count(crossAxisCellCount: 5, mainAxisCellCount: 2, child: displayJvmInformation()),
        StaggeredGridTile.count(crossAxisCellCount: 2, mainAxisCellCount: 1, child: displayBrandLabel()),
        StaggeredGridTile.count(crossAxisCellCount: 5, mainAxisCellCount: 2, child: displayActionButtons()),
        StaggeredGridTile.count(crossAxisCellCount: 3, mainAxisCellCount: 3, child: displayHardwareInformation()),
      ],
    );
  }

  Widget displayBrandLabel() {
    return Center(child: Text('JOS', style: GoogleFonts.smoochSans(letterSpacing: 3, color: Colors.white, fontSize: 55, fontWeight: FontWeight.bold)));
  }

  Widget displayActionButtons() {
    return MouseRegion(
      onHover: (_) => setState(() => _mouseHoverOnActionBox = true),
      onExit: (_) => setState(() => _mouseHoverOnActionBox = false),
      child: Container(
        decoration: BoxDecoration(color: dashboardMosaicBackgroundColor, border: Border.all(color: _mouseHoverOnActionBox ? Colors.white : Colors.transparent)),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: actionButton(Icons.power_settings_new, 'System PowerOff', Colors.redAccent, jvmController.callJvmGarbageCollector, false),
              ),
              SizedBox(
                width: 80,
                height: 80,
                child: actionButton(Icons.autorenew_rounded, 'JVM Restart', Colors.white, jvmController.callJvmRestart, jvmController.jvmNeedRestart.isTrue),
              ),
              SizedBox(
                width: 80,
                height: 80,
                child: actionButton(Icons.recycling_outlined, 'JVM GC', Colors.white, jvmController.callJvmGarbageCollector, false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget displayJvmInformation() {
    return MouseRegion(
      onHover: (_) => setState(() => _mouseHoverOnJVMBox = true),
      onExit: (_) => setState(() => _mouseHoverOnJVMBox = false),
      child: Container(
        decoration: BoxDecoration(color: dashboardMosaicBackgroundColor, border: Border.all(color: _mouseHoverOnJVMBox ? Colors.white : Colors.transparent)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('JVM Vendor', style: TextStyle(fontWeight: FontWeight.bold, color: _mouseHoverOnJVMBox ? Colors.white : Colors.grey, fontSize: 12)),
                  Text(systemController.jvmVendor.value, style: TextStyle(color: _mouseHoverOnJVMBox ? Colors.white : Colors.grey, fontSize: 12)),
                  SizedBox(height: 12),
                  Text('JVM Version', style: TextStyle(fontWeight: FontWeight.bold, color: _mouseHoverOnJVMBox ? Colors.white : Colors.grey, fontSize: 12)),
                  Text(systemController.jvmVersion.value, style: TextStyle(color: _mouseHoverOnJVMBox ? Colors.white : Colors.grey, fontSize: 12)),
                ],
              ),
              SizedBox(width: 60),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('JVM Xmx', style: TextStyle(fontWeight: FontWeight.bold, color: _mouseHoverOnJVMBox ? Colors.white : Colors.grey, fontSize: 12)),
                  Text(formatSize(systemController.jvmMaxHeapSize.value), style: TextStyle(color: _mouseHoverOnJVMBox ? Colors.white : Colors.grey, fontSize: 12)),
                  SizedBox(height: 8),
                  Text('JVM Xms', style: TextStyle(fontWeight: FontWeight.bold, color: _mouseHoverOnJVMBox ? Colors.white : Colors.grey, fontSize: 12)),
                  Text(formatSize(systemController.jvmTotalHeapSize.value), style: TextStyle(color: _mouseHoverOnJVMBox ? Colors.white : Colors.grey, fontSize: 12)),
                  SizedBox(height: 8),
                  Text('JVM used heap', style: TextStyle(fontWeight: FontWeight.bold, color: _mouseHoverOnJVMBox ? Colors.white : Colors.grey, fontSize: 12)),
                  Text(formatSize(systemController.jvmUsedHeapSize.value), style: TextStyle(color: _mouseHoverOnJVMBox ? Colors.white : Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget displayHardwareInformation() {
    return MouseRegion(
      onHover: (_) => setState(() => _mouseHoverOnHWBox = true),
      onExit: (_) => setState(() => _mouseHoverOnHWBox = false),
      child: Container(
        decoration: BoxDecoration(color: dashboardMosaicBackgroundColor, border: Border.all(color: _mouseHoverOnHWBox ? Colors.white : Colors.transparent)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('CPU Model', style: TextStyle(fontWeight: FontWeight.bold, color: _mouseHoverOnHWBox ? Colors.white : Colors.grey, fontSize: 12)),
              Text(systemController.hwCpuInfo.value, style: TextStyle(color: _mouseHoverOnHWBox ? Colors.white : Colors.grey, fontSize: 12)),
              SizedBox(height: 12),
              Text('CPU Cores', style: TextStyle(fontWeight: FontWeight.bold, color: _mouseHoverOnHWBox ? Colors.white : Colors.grey, fontSize: 12)),
              Text(systemController.hwCpuCount.value, style: TextStyle(color: _mouseHoverOnHWBox ? Colors.white : Colors.grey, fontSize: 12)),
              SizedBox(height: 12),
              Text('Total RAM', style: TextStyle(fontWeight: FontWeight.bold, color: _mouseHoverOnHWBox ? Colors.white : Colors.grey, fontSize: 12)),
              Text(formatSize(systemController.hwTotalMemory.value), style: TextStyle(color: _mouseHoverOnHWBox ? Colors.white : Colors.grey, fontSize: 12)),
              SizedBox(height: 12),
              Text('Used RAM', style: TextStyle(fontWeight: FontWeight.bold, color: _mouseHoverOnHWBox ? Colors.white : Colors.grey, fontSize: 12)),
              Text(formatSize(systemController.hwUsedMemory.value), style: TextStyle(color: _mouseHoverOnHWBox ? Colors.white : Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget displayBasicInformation() {
    return MouseRegion(
      onHover: (_) => setState(() => _mouseHoverOnBasicBox = true),
      onExit: (_) => setState(() => _mouseHoverOnBasicBox = false),
      child: Container(
        decoration: BoxDecoration(color: dashboardMosaicBackgroundColor, border: Border.all(color: _mouseHoverOnBasicBox ? Colors.white : Colors.transparent)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('OS', style: TextStyle(fontWeight: FontWeight.bold, color: _mouseHoverOnBasicBox ? Colors.white : Colors.grey, fontSize: 12)),
              Text('${systemController.osType.value} ${systemController.osVersion.value}',
                  style: TextStyle(color: _mouseHoverOnBasicBox ? Colors.white : Colors.grey, fontSize: 12)),
              SizedBox(height: 12),
              Text('Hostname', style: TextStyle(fontWeight: FontWeight.bold, color: _mouseHoverOnBasicBox ? Colors.white : Colors.grey, fontSize: 12)),
              Text(systemController.osHostname.value, style: TextStyle(color: _mouseHoverOnBasicBox ? Colors.white : Colors.grey, fontSize: 12)),
              SizedBox(height: 12),
              Text('Username', style: TextStyle(fontWeight: FontWeight.bold, color: _mouseHoverOnBasicBox ? Colors.white : Colors.grey, fontSize: 12)),
              Text(systemController.osUsername.value, style: TextStyle(color: _mouseHoverOnBasicBox ? Colors.white : Colors.grey, fontSize: 12)),
              SizedBox(height: 12),
              Text('Date & Time', style: TextStyle(fontWeight: FontWeight.bold, color: _mouseHoverOnBasicBox ? Colors.white : Colors.grey, fontSize: 12)),
              Text(systemController.dateTimeZone.value, style: TextStyle(color: _mouseHoverOnBasicBox ? Colors.white : Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
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
        child: Visibility(
          visible: rotateIcon,
          replacement: Icon(icon, size: 40),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (_, child) => Transform.rotate(angle: _animationController.value * 2 * math.pi, child: child),
            child: Icon(icon, size: 40),
          ),
        ),
      ),
    );
  }
}
