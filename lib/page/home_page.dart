import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jos_ui/component/top_menu_component.dart';
import 'package:jos_ui/page_base_content.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  bool mouseOnHardwareInformation = false;
  bool mouseOnBaseInformation = false;
  bool mouseOnCpuChart = false;
  bool mouseOnMemoryChart = false;

  @override
  void initState() {
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
          mouseOnCpuChart = true;
        });
      },
      onExit: (_) {
        setState(() {
          mouseOnCpuChart = false;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: mouseOnCpuChart ? Colors.white : Colors.transparent),
          color: mouseOnCpuChart ? Colors.lightGreen : Colors.green,
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
          mouseOnMemoryChart = true;
        });
      },
      onExit: (_) {
        setState(() {
          mouseOnMemoryChart = false;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: mouseOnMemoryChart ? Colors.white : Colors.transparent),
          color: mouseOnMemoryChart ? Colors.lightGreen : Colors.green,
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
          mouseOnHardwareInformation = true;
        });
      },
      onExit: (_) {
        setState(() {
          mouseOnHardwareInformation = false;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: mouseOnHardwareInformation ? Colors.white : Colors.transparent),
          color: mouseOnHardwareInformation ? Colors.lightGreen : Colors.green,
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
          mouseOnBaseInformation = true;
        });
      },
      onExit: (_) {
        setState(() {
          mouseOnBaseInformation = false;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: mouseOnBaseInformation ? Colors.white : Colors.transparent),
          color: mouseOnBaseInformation ? Colors.lightGreen : Colors.green,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Version', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
              Text('1.1', style: TextStyle(color: Colors.white, fontSize: 10)),
              SizedBox(height: 12),
              Text('Hostname', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
              Text('Skynet-pc', style: TextStyle(color: Colors.white, fontSize: 10)),
              SizedBox(height: 12),
              Text('Username', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
              Text('admin', style: TextStyle(color: Colors.white, fontSize: 10)),
              SizedBox(height: 12),
              Text('Date & Time', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
              Text('Thu Nov 23 09:46:23 PM (Asia/Tehran)', style: TextStyle(color: Colors.white, fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }
}
