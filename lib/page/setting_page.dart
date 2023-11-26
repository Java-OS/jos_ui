import 'package:flutter/material.dart';
import 'package:jos_ui/component/date_time_component.dart';
import 'package:jos_ui/component/environment_component.dart';
import 'package:jos_ui/component/network_component.dart';
import 'package:jos_ui/component/ntp_component.dart';
import 'package:jos_ui/component/side_menu_component.dart';
import 'package:jos_ui/component/top_menu_component.dart';
import 'package:jos_ui/page_base_content.dart';

class SettingPage extends StatefulWidget {
  final int tabIndex;

  const SettingPage({super.key, required this.tabIndex});

  @override
  State<SettingPage> createState() => _SystemPageState();
}

class _SystemPageState extends State<SettingPage> {
  bool useNtp = false;

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
          children: [
            TopMenuComponent(selectedIndex: 1),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [SideMenuComponent(indexTab: widget.tabIndex), chooseTargetTab()],
            ),
          ],
        ),
      ),
    );
  }

  Widget chooseTargetTab() {
    switch (widget.tabIndex) {
      case 0:
        return displayBasicContent();
      case 1:
        return displayDateAndTimeContent();
      case 2:
        return displayNetworkContent();
      case 3:
        return displayEnvironmentsContent();
      default:
        return displayBasicContent();
    }
  }

  Widget displayBasicContent() {
    return basicContent(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Basic Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
              SizedBox(height: 30),
              Text('Hostname', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(decoration: InputDecoration(hintText: 'Enter hostname', hintStyle: TextStyle(fontSize: 12))),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [ElevatedButton(onPressed: () {}, child: Text('Apply'))],
          )
        ],
      ),
    );
  }

  Widget displayDateAndTimeContent() {
    return basicContent(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date and Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
              SizedBox(height: 30),
              Row(
                children: [
                  Checkbox(
                      value: useNtp,
                      onChanged: (e) {
                        setState(() {
                          useNtp = e!;
                        });
                      }),
                  SizedBox(width: 4),
                  Text('Set date and time automatically', style: TextStyle()),
                ],
              ),
              SizedBox(height: 30),
              Visibility(visible: useNtp, replacement: DateTimeComponent(), child: NTPComponent())
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(onPressed: () {}, child: Text('Apply'))
            ],
          )
        ],
      ),
    );
  }

  Widget displayNetworkContent() {
    return basicContent(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Network', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
              SizedBox(height: 30),
              NetworkComponent(),
              SizedBox(height: 30),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(onPressed: () {}, child: Text('Apply'))
            ],
          )
        ],
      ),
    );
  }

  Widget displayEnvironmentsContent() {
    return basicContent(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Environments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
              SizedBox(height: 30),
              EnvironmentComponent(),
              SizedBox(height: 30),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(onPressed: () {}, child: Text('Apply'))
            ],
          )
        ],
      ),
    );
  }

  Widget basicContent({child}) {
    return Container(
      width: 520,
      height: 400,
      color: Color.fromRGBO(236, 226, 226, 1.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}
