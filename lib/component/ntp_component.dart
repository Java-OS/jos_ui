import 'package:flutter/material.dart';

class NTPComponent extends StatelessWidget {
  const NTPComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('NTP Server', style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(decoration: InputDecoration(hintText: 'Enter ntp address', hintStyle: TextStyle(fontSize: 12))),
        SizedBox(height: 30),
        SizedBox(width: 100, child: ElevatedButton(onPressed: () {}, child: Row(children: const [Icon(Icons.sync,size: 16), SizedBox(width: 4), Text('Sync')]))),
      ],
    );
  }
}
