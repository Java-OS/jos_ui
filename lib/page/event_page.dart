import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jos_ui/component/card_content.dart';
import 'package:jos_ui/component/tile.dart';
import 'package:jos_ui/controller/event_controller.dart';
import 'package:jos_ui/message_buffer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => EventPageState();
}

class EventPageState extends State<EventPage> {
  final _eventController = Get.put(EventController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _eventController.eventFetch());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardContent(
      controllers: [
        OutlinedButton(onPressed: _eventController.hasUnreadEvent() ? () => _eventController.eventReadAll() : null, child: Icon(Icons.done_all_outlined, size: 16)),
      ],
      child: Expanded(
        child: SingleChildScrollView(
          child: Obx(
            () => ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _eventController.listEvents.length,
              itemBuilder: (context, index) {
                var event = _eventController.listEvents[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TileItem(
                    actions: SizedBox(
                      width: 100,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (!event.read)
                            IconButton(
                              onPressed: () => _eventController.eventRead(event.uid!),
                              splashRadius: 12,
                              icon: Icon(Icons.check, size: 16, color: Colors.black),
                            ),
                        ],
                      ),
                    ),
                    leading: CircleAvatar(backgroundColor: Colors.black12, child: getEventIcon(event)),
                    index: index,
                    title: Text(event.message!, style: TextStyle(color: event.read ? Colors.grey : Colors.black)),
                    subTitle: Text(
                      formatDate(event.uid!),
                      style: TextStyle(color: event.read ? Colors.grey : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String formatDate(String timestamp) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    return DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);
  }

  Icon getEventIcon(Event event) {
    switch (event.eventStatus) {
      case EventStatus.PROGRESS:
        return Icon(MdiIcons.timelapse, color: event.read ? Colors.grey : Colors.black);
      case EventStatus.FAILURE:
        return Icon(Icons.error_outline, color: event.read ? Colors.grey : Colors.black);
      case EventStatus.SUCCESS:
        return Icon(Icons.info_outline, color: event.read ? Colors.grey : Colors.black);
      default:
        return Icon(Icons.info_outline, color: event.read ? Colors.grey : Colors.black);
    }
  }
}
