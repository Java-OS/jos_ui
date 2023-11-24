import 'package:flutter/material.dart';

class DateTimeComponent extends StatelessWidget {
  const DateTimeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedButton(onPressed: () => _showDatePicker(context), child: Text('2023/10/18')),
        SizedBox(width: 8),
        OutlinedButton(onPressed: () => _showTimePicker(context), child: Text('22:55')),
      ],
    );
  }

  void _showDatePicker(BuildContext context) {
    var now = DateTime.now();
    var first = now.copyWith(year: now.year - 8);
    var last = now.copyWith(year: now.year + 9);
    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: first, lastDate: last);
  }

  void _showTimePicker(BuildContext context) {
    var timeOfDay = TimeOfDay.now();
    showTimePicker(context: context, initialTime: timeOfDay);
  }
}
