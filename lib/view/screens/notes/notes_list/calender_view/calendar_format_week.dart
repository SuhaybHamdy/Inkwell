import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inkwell/models/note.dart';

import '../../../../../controllers/note_controller.dart'; // Update this path according to your project structure

class BuildWeekView extends StatelessWidget {
  final List<Note> notes;

  BuildWeekView({required this.notes});

  @override
  Widget build(BuildContext context) {
    // DateTime now = DateTime.now();
    // DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    // DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
    // EventController<Object?> eventController = EventController<Object?>();

    // List<Note> weekNotes = notes.where((note) {
    //   DateTime? startTime = note.repeatInterval?.startDate ?? note.lastEdited;
    //   DateTime? endTime = note.repeatInterval?.endDate ?? note.lastEdited;

    //   return startTime!.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
    //       endTime!.isBefore(endOfWeek.add(const Duration(days: 1)));
    // }).toList();
// for (var note in weekNotes) {
//   eventController.add(CalendarEventData(
//     titleStyle: Get.textTheme.bodySmall,
//     event: note,
//     color: note.color ?? Colors.blue,
//     title: note.title ?? 'No Title',
//     date: note.lastEdited ?? DateTime.now(),
//     startTime: note.repeatInterval?.startDate ?? DateTime.now(),
//     endTime: note.repeatInterval?.endDate ?? DateTime.now().add(Duration(hours: 1)),
//   ));
// }
    return Scaffold(
      appBar: AppBar(
        title: Text('Week View'),
      ),
      body: WeekViewWidget(),
    );
  }
}
    // NotesController controller = Get.find();

class WeekViewWidget extends GetView<NotesController> {

  const WeekViewWidget({Key? key,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WeekView(
      controller: controller.eventController,
      showLiveTimeLineInAllDays: true,
      timeLineWidth: 20,
      startDay: WeekDays.saturday,
      liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
        color: Colors.redAccent,
        showTime: true,
      ),
      onEventTap: (events, date) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Event Tapped")));
      },
      onEventLongTap: (events, date) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Event Long-Tapped")));
      },
    );
  }
}
