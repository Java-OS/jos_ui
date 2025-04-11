import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/component/drop_down.dart';
import 'package:jos_ui/controller/graph_controller.dart';
import 'package:jos_ui/model/graph_timeframe.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  final _graphController = Get.put(GraphController());

  double dx = 0;
  double dy = 0;
  int _onHoverIndex = -1;
  Timer? _timer;
  double? _width;
  double height = 150;
  bool _initFetchDone = false;
  Completer<void>? _requestCompleter;

  @override
  void initState() {
    super.initState();

    // Start fetching after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer.periodic(Duration(minutes: 1), (_) async {
        if (_width != null && (_requestCompleter == null || _requestCompleter!.isCompleted)) {
          try {
            _requestCompleter = Completer<void>();
            developer.log('Timer try to fetch graph');
            await _graphController.fetchGraph(_width!, height, true);
          } finally {
            _requestCompleter!.complete();
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) {
        var width = box.maxWidth;
        if (!_initFetchDone || _width != width) {
          _width = width; // Store width in state
          _graphController.fetchGraph(_width!, height, false);
          _initFetchDone = true;
        }
        return Obx(
          () {
            return CardContent(
              controllers: [
                OutlinedButton(onPressed: () => _graphController.fetchGraph(_width!, height, true), child: Icon(Icons.refresh, size: 16)),
                SizedBox(
                  width: 100,
                  child: DropDownMenu<GraphTimeframe>(
                    requiredValue: true,
                    displayClearButton: false,
                    value: _graphController.timeframe.value,
                    items: List.generate(GraphTimeframe.values.length, (index) => DropdownMenuItem(value: GraphTimeframe.values[index], child: Text(GraphTimeframe.values[index].name))),
                    onChanged: (tf) {
                      _graphController.timeframe.value = tf;
                      _graphController.fetchGraph(_width!, height, true);
                    },
                  ),
                )
              ],
              child: Expanded(
                child: ReorderableList(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.zero,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _graphController.graphList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return chartWidget(index);
                  },
                  onReorder: (int oldIndex, int newIndex) => updateOrder(oldIndex, newIndex),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget chartWidget(int index) {
    var graph = _graphController.graphList[index];
    return ReorderableDragStartListener(
      key: ValueKey(graph.name),
      index: index,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MouseRegion(
          cursor: _onHoverIndex == index ? SystemMouseCursors.grab : SystemMouseCursors.basic,
          onHover: (e) => setState(() => _onHoverIndex = index),
          onExit: (e) => setState(() => _onHoverIndex = -1),
          child: Material(
            elevation: _onHoverIndex == index ? 8 : 0,
            child: Image.memory(
              gaplessPlayback: true,
              graph.bytes,
            ),
          ),
        ),
      ),
    );
  }

  void updateOrder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) newIndex--;
      var rule = _graphController.graphList.removeAt(oldIndex);
      _graphController.graphList.insert(newIndex, rule);
      _graphController.sortGraph();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer?.cancel();
  }
}
