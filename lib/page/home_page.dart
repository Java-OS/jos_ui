import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jos_ui/component/top_menu_component.dart';
import 'package:jos_ui/model/rpc.dart';
import 'package:jos_ui/page_base_content.dart';
import 'package:jos_ui/service/rest_api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _mouseOnHardwareInformation = false;
  bool _mouseOnBaseInformation = false;
  bool _mouseOnCpuChart = false;
  bool _mouseOnMemoryChart = false;

  String _osUsername = '';
  String _osType = '';
  String _osVersion = '';
  String _osHostname = '';
  String _hwCpuInfo = '';
  String _hwCpuCount = '';
  String _hwTotalMemory = '';
  String _hwUsedMemory = '';
  String _hwFreeMemory = '';
  String _jvmVendor = '';
  String _jvmVersion = '';
  String _jvmMaxHeapSize = '';
  String _jvmTotalHeapSize = '';
  String _jvmUsedHeapSize = '';
  String _dateTimeZone = '';

  @override
  void initState() {
    _fetchFullSystemInformation();
    _fetchSystemDateTimeZone();
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
    return MouseRegion(
      onHover: (_) {
        setState(() {
          _mouseOnCpuChart = true;
        });
      },
      onExit: (_) {
        setState(() {
          _mouseOnCpuChart = false;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: _mouseOnCpuChart ? Colors.white : Colors.transparent),
          color: _mouseOnCpuChart ? Colors.lightGreen : Colors.green,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('H2'),
        ),
      ),
    );
  }

  Widget displayMemoryChart() {
    return MouseRegion(
      onHover: (_) {
        setState(() {
          _mouseOnMemoryChart = true;
        });
      },
      onExit: (_) {
        setState(() {
          _mouseOnMemoryChart = false;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: _mouseOnMemoryChart ? Colors.white : Colors.transparent),
          color: _mouseOnMemoryChart ? Colors.lightGreen : Colors.green,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('H2'),
        ),
      ),
    );
  }

  Widget displayHardwareInformation() {
    return MouseRegion(
      onHover: (_) {
        setState(() {
          _mouseOnHardwareInformation = true;
        });
      },
      onExit: (_) {
        setState(() {
          _mouseOnHardwareInformation = false;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: _mouseOnHardwareInformation ? Colors.white : Colors.transparent),
          color: _mouseOnHardwareInformation ? Colors.lightGreen : Colors.green,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('CPU', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
              Text('Intel Core i7-4702MQ', style: TextStyle(color: Colors.white, fontSize: 10)),
              SizedBox(height: 22),
              Text('RAM', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
              Text('5G', style: TextStyle(color: Colors.white, fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  Widget displayBasicInformation() {
    return MouseRegion(
      onHover: (_) {
        setState(() {
          _mouseOnBaseInformation = true;
        });
      },
      onExit: (_) {
        setState(() {
          _mouseOnBaseInformation = false;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: _mouseOnBaseInformation ? Colors.white : Colors.transparent),
          color: _mouseOnBaseInformation ? Colors.lightGreen : Colors.green,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Version', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
              Text(_osVersion, style: TextStyle(color: Colors.white, fontSize: 10)),
              SizedBox(height: 12),
              Text('Hostname', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
              Text(_osHostname, style: TextStyle(color: Colors.white, fontSize: 10)),
              SizedBox(height: 12),
              Text('Username', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
              Text(_osUsername, style: TextStyle(color: Colors.white, fontSize: 10)),
              SizedBox(height: 12),
              Text('Date & Time', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
              Text(_dateTimeZone, style: TextStyle(color: Colors.white, fontSize: 10)),
            ],
          ),
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
        _osUsername = json['result']['os_username'].toString();
        _osVersion = json['result']['os_version'].toString();
        _osHostname = json['result']['os_hostname'].toString();
        _hwCpuInfo = json['result']['hw_cpu_info'].toString();
        _hwCpuCount = json['result']['hw_cpu_count'].toString();
        _hwTotalMemory = json['result']['hw_total_memory'].toString();
        _hwUsedMemory = json['result']['hw_used_memory'].toString();
        _hwFreeMemory = json['result']['hw_free_memory'].toString();
        _jvmVendor = json['result']['jvm_vendor'].toString();
        _jvmVersion = json['result']['jvm_version'].toString();
        _jvmMaxHeapSize = json['result']['jvm_max_heap_size'].toString();
        _jvmTotalHeapSize = json['result']['jvm_total_heap_size'].toString();
        _jvmUsedHeapSize = json['result']['jvm_used_heap_size'].toString();
      });
    }
  }

  void _fetchSystemDateTimeZone() async {
    developer.log('Fetch System Date Time Zone called');
    var response = await RestApiService.rpc(RPC.dateTimeInformation);
    if (response != null) {
      var json = jsonDecode(response);
      setState(() {
        var dateTimeZone = json['result']['zonedDateTime'];
        List<String> dateTimeZoneParts = dateTimeZone.toString().split(RegExp(r'Z'));
        List<String> dateTimeParts = dateTimeZoneParts[0].toString().split(RegExp(r'T'));
        String formattedString = '${dateTimeParts[0]} ${dateTimeParts[1]} ${dateTimeZoneParts[1]}';
        _dateTimeZone = formattedString;
      });
    }
  }
}
