import 'package:flutter/material.dart';
import 'package:jos_ui/utils.dart';

class BarChart extends StatefulWidget {
  final int total;
  final int? current;
  final String? text;
  final TextStyle? textStyle;
  final Color? main;
  final Color? warn;
  final double? height;

  const BarChart({super.key, required this.total, this.current, this.text, this.main = Colors.blue, this.warn = Colors.red, this.height = 28, this.textStyle});

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        var usedPercentage = (widget.current ?? 0) * 100 / widget.total;
        var used = constraints.maxWidth * usedPercentage / 100;
        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.2),
              ),
              height: widget.height!,
            ),
            Container(
              width: used ,
              color: usedPercentage < 80 ? widget.main : widget.warn ,
              height: widget.height,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(parseText(), style: widget.textStyle),
            ),
          ],
        );
      },
    );
  }

  String parseText() {
    var total = formatSize(widget.total * 1024);
    var current = formatSize((widget.current ?? 0) * 1024);

    return '${widget.text ?? ''} $current/$total';
  }
}
