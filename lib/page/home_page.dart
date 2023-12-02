import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jos_ui/component/top_menu_component.dart';
import 'package:jos_ui/constant.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/page_base_content.dart';
import 'package:jos_ui/service/rest_api_service.dart';
import 'package:jos_ui/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _osUsername = '';
  String _osType = '';
  String _osVersion = '';
  String _osHostname = '';
  String _hwCpuInfo = '';
  String _hwCpuCount = '';
  int _hwTotalMemory = 0;
  int _hwUsedMemory = 0;
  int _hwFreeMemory = 0;
  String _jvmVendor = '';
  String _jvmVersion = '';
  int _jvmMaxHeapSize = 0;
  int _jvmTotalHeapSize = 0;
  int _jvmUsedHeapSize = 0;
  String _dateTimeZone = '';

  @override
  void initState() {
    _fetchFullSystemInformation();
    super.initState();
  }

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
          children: [TopMenuComponent(selectedIndex: 0), SizedBox(height: 8), mosaicView()],
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
    return Container(
      color: dashboardMosaicBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: actionButton(Icons.power_settings_new,'System PowerOff', _callJvmGarbageCollector),
            ),
            SizedBox(
              width: 80,
              height: 80,
              child: actionButton(Icons.autorenew_rounded,'JVM Restart', _callJvmRestart),
            ),
            SizedBox(
              width: 80,
              height: 80,
              child: actionButton(Icons.recycling_outlined,'JVM GC', _callJvmGarbageCollector),
            ),
          ],
        ),
      ),
    );
  }

  Widget displayJvmInformation() {
    return Container(
      color: dashboardMosaicBackgroundColor,
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
                Text('JVM Vendor', style: dashboardMosaicTitleStyle),
                Text(_jvmVendor, style: dashboardMosaicTextStyle),
                SizedBox(height: 12),
                Text('JVM Version', style: dashboardMosaicTitleStyle),
                Text(_jvmVersion, style: dashboardMosaicTextStyle),
              ],
            ),
            SizedBox(width: 60),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('JVM Xmx', style: dashboardMosaicTitleStyle),
                Text(formatSize(_jvmMaxHeapSize), style: dashboardMosaicTextStyle),
                SizedBox(height: 8),
                Text('JVM Xms', style: dashboardMosaicTitleStyle),
                Text(formatSize(_jvmTotalHeapSize), style: dashboardMosaicTextStyle),
                SizedBox(height: 8),
                Text('JVM used heap', style: dashboardMosaicTitleStyle),
                Text(formatSize(_jvmUsedHeapSize), style: dashboardMosaicTextStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget displayHardwareInformation() {
    return Container(
      color: dashboardMosaicBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('CPU Model', style: dashboardMosaicTitleStyle),
            Text(_hwCpuInfo, style: dashboardMosaicTextStyle),
            SizedBox(height: 12),
            Text('CPU Cores', style: dashboardMosaicTitleStyle),
            Text(_hwCpuCount, style: dashboardMosaicTextStyle),
            SizedBox(height: 12),
            Text('Total RAM', style: dashboardMosaicTitleStyle),
            Text(formatSize(_hwTotalMemory), style: dashboardMosaicTextStyle),
            SizedBox(height: 12),
            Text('Used RAM', style: dashboardMosaicTitleStyle),
            Text(formatSize(_hwUsedMemory), style: dashboardMosaicTextStyle),
          ],
        ),
      ),
    );
  }

  Widget displayBasicInformation() {
    return Container(
      color: dashboardMosaicBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version', style: dashboardMosaicTitleStyle),
            Text(_osVersion, style: dashboardMosaicTextStyle),
            SizedBox(height: 12),
            Text('Hostname', style: dashboardMosaicTitleStyle),
            Text(_osHostname, style: dashboardMosaicTextStyle),
            SizedBox(height: 12),
            Text('Username', style: dashboardMosaicTitleStyle),
            Text(_osUsername, style: dashboardMosaicTextStyle),
            SizedBox(height: 12),
            Text('Date & Time', style: dashboardMosaicTitleStyle),
            Text(_dateTimeZone, style: dashboardMosaicTextStyle),
          ],
        ),
      ),
    );
  }

  void _fetchFullSystemInformation() async {
    developer.log('Fetch Os Version called');
    var response = await RestClient.rpc(RPC.systemFullInformation);
    if (response != null) {
      var json = jsonDecode(response);
      setState(() {
        _dateTimeZone = json['result']['os_date_time_zone'].toString();
        _osUsername = json['result']['os_username'].toString();
        _osVersion = json['result']['os_version'].toString();
        _osHostname = json['result']['os_hostname'].toString();
        _hwCpuInfo = json['result']['hw_cpu_info'].toString();
        _hwCpuCount = json['result']['hw_cpu_count'].toString();
        _hwTotalMemory = json['result']['hw_total_memory'];
        _hwUsedMemory = json['result']['hw_used_memory'];
        _hwFreeMemory = json['result']['hw_free_memory'];
        _jvmVendor = json['result']['jvm_vendor'].toString();
        _jvmVersion = json['result']['jvm_version'].toString();
        _jvmMaxHeapSize = json['result']['jvm_max_heap_size'];
        _jvmTotalHeapSize = json['result']['jvm_total_heap_size'];
        _jvmUsedHeapSize = json['result']['jvm_used_heap_size'];
      });
    }
  }

  void _callJvmGarbageCollector() async {
    developer.log('JVM Garbage Collector called');
    RestClient.rpc(RPC.jvmGc).then((_) => _fetchFullSystemInformation());
  }

  void _callJvmRestart() async {
    developer.log('JVM restart called');
    RestClient.rpc(RPC.jvmRestart).then((_) => _fetchFullSystemInformation());
  }

  Widget actionButton(IconData icon,String tooltipMessage, Function callApiMethod) {
    return Tooltip(
      preferBelow: false,
      verticalOffset: 45,
      message: tooltipMessage,
      child: OutlinedButton(
        style: ButtonStyle(
          side: MaterialStateProperty.resolveWith<BorderSide>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return BorderSide(color: Colors.white);
              }
              return BorderSide(color: Colors.white38);
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return Colors.white; // Set the hover icon color
              }
              return Colors.white38; // Set the default icon color
            },
          ),
        ),
        onPressed: () => callApiMethod(),
        child: Icon(icon, size: 40),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
