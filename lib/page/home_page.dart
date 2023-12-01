import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jos_ui/component/LineChartSample2.dart';
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
  late Timer _timer ;
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
    // _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _fetchFullSystemInformation();
    // });
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
        StaggeredGridTile.count(crossAxisCellCount: 5, mainAxisCellCount: 2, child: displayCpuChart()),
        StaggeredGridTile.count(crossAxisCellCount: 2, mainAxisCellCount: 1, child: displayJosMessage()),
        StaggeredGridTile.count(crossAxisCellCount: 5, mainAxisCellCount: 2, child: displayMemoryChart()),
        StaggeredGridTile.count(crossAxisCellCount: 3, mainAxisCellCount: 3, child: displayHardwareInformation()),
      ],
    );
  }

  Widget displayJosMessage() {
    return Center(child: Text('JOS', style: GoogleFonts.smoochSans(letterSpacing: 3, color: Colors.white, fontSize: 55, fontWeight: FontWeight.bold)));
  }

  Widget displayCpuChart() {
    return Container(
      color: componentBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: PieChart(
                PieChartData(
                  // centerSpaceRadius: 25,
                  startDegreeOffset: 270,
                  sections: [
                    PieChartSectionData(
                      titleStyle: TextStyle(fontSize: 10),
                      title: formatSize(_jvmMaxHeapSize),
                      value: _jvmMaxHeapSize as double,
                      color: Colors.blue
                    ),
                    PieChartSectionData(
                        titleStyle: TextStyle(fontSize: 10),
                        title: formatSize(_jvmUsedHeapSize),
                        value: 29238392334,
                        color: Colors.red
                    )
                  ]
                )
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget displayMemoryChart() {
    return Container(
      color: componentBackgroundColor,
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
                Text('JVM Vendor', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
                Text(_jvmVendor, style: TextStyle(color: Colors.black, fontSize: 10)),
                SizedBox(height: 12),
                Text('JVM Version', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
                Text(_jvmVersion, style: TextStyle(color: Colors.black, fontSize: 10)),
              ],
            ),
            SizedBox(width: 60),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('JVM Xmx', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
                Text(formatSize(_jvmMaxHeapSize), style: TextStyle(color: Colors.black, fontSize: 10)),
                SizedBox(height: 8),
                Text('JVM Xms', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
                Text(formatSize(_jvmTotalHeapSize), style: TextStyle(color: Colors.black, fontSize: 10)),
                SizedBox(height: 8),
                Text('JVM used heap size', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
                Text(formatSize(_jvmUsedHeapSize), style: TextStyle(color: Colors.black, fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget displayHardwareInformation() {
    return Container(
      color: componentBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('CPU Model', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
            Text(_hwCpuInfo, style: TextStyle(color: Colors.black, fontSize: 10)),
            SizedBox(height: 12),
            Text('CPU Cores', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
            Text(_hwCpuCount, style: TextStyle(color: Colors.black, fontSize: 10)),
            SizedBox(height: 12),
            Text('Total RAM', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
            Text(formatSize(_hwTotalMemory), style: TextStyle(color: Colors.black, fontSize: 10)),
            SizedBox(height: 12),
            Text('Used RAM', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
            Text(formatSize(_hwUsedMemory), style: TextStyle(color: Colors.black, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget displayBasicInformation() {
    return Container(
      color: componentBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
            Text(_osVersion, style: TextStyle(color: Colors.black, fontSize: 10)),
            SizedBox(height: 12),
            Text('Hostname', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
            Text(_osHostname, style: TextStyle(color: Colors.black, fontSize: 10)),
            SizedBox(height: 12),
            Text('Username', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
            Text(_osUsername, style: TextStyle(color: Colors.black, fontSize: 10)),
            SizedBox(height: 12),
            Text('Date & Time', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
            Text(_dateTimeZone, style: TextStyle(color: Colors.black, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  void _fetchFullSystemInformation() async {
    developer.log('Fetch Os Version called');
    var response = await RestApiService.rpc(RPC.systemFullInformation);
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

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}
