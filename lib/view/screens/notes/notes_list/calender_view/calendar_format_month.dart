import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:inkwell/models/note.dart';
import 'package:intl/intl.dart';

import '../../../../../controllers/note_controller.dart';
import '../../../../../routes/app_routes.dart';
import 'calendar_format_day.dart';

class BuildMonthView extends GetView<NotesController> {
  final List<Note> notes;

  var isDay = false;

  BuildMonthView({required this.notes});

  @override
  Widget build(BuildContext context) {
    // Initialize an EventController and populate it with events
    // EventController<Object?> eventController = EventController<Object?>();

    // for (var note in notes) {
    //   eventController.add(CalendarEventData(
    //       event: note,
    //       title: note.title ?? 'No Title',
    //       description: note.content ?? 'No Content',
    //       date:  note.lastEdited ?? DateTime.now(),
    //       startTime: note.repeatInterval?.startDate,
    //       endDate: note.repeatInterval?.endDate
    //   ));
    // }
    var eventController = controller.eventController;
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Container(
        child: MonthView(
          controller: eventController,
          cellBuilder: (date, events, isToday, isInMonth, hideDaysNotInMonth) {
            return _cellBuilder(
                date, events, isToday, isInMonth, hideDaysNotInMonth);
          },
          minMonth: DateTime(1990),
          maxMonth: DateTime(2050),
          initialMonth: DateTime.now(),
          cellAspectRatio: 0.47,
          onPageChange: (date, pageIndex) => print("month $date, $pageIndex"),
          onCellTap: onCellTap,
          startDay: WeekDays.saturday,
          onEventTap: (event, date) => print(event),
          onEventDoubleTap: (events, date) => print(events),
          onEventLongTap: (event, date) => print(event),
          onDateLongPress: (date) => print(date),
          headerBuilder: MonthHeader.hidden,
          showWeekTileBorder: true,
          hideDaysNotInMonth: true,
        ),
      ),
    );
  }

  Widget _cellBuilder(DateTime date, List<CalendarEventData<Object?>> events,
      bool isToday, bool isInMonth, bool hideDaysNotInMonth) {
    final theme = Get.theme;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 400,
      decoration: BoxDecoration(
        color: isToday
            ? theme.colorScheme.secondary.withOpacity(0.3)
            : theme.colorScheme.surface,
        // border: Border.all(color: theme.dividerColor),
      ),
      // padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat.d().format(date).tr,
            style: TextStyle(
              // fontWeight: FontWeight.bold,
              color: isToday
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
            ),
          ),
          if (events.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return Container(
                    margin: EdgeInsets.all(1.0),
                    // padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      event.title,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _showNotesDialog(
      BuildContext context,
      DateTime selectedDay,
      List<Note> notes,
      List<CalendarEventData<Object?>> events,
      EventController<Object?> eventController) {
    showDialog(
      context: context,
      builder: (context) {
        final dayNotes = notes.where((note) {
          final date = note.lastEdited;
          return date != null && _isSameDayMonth(date, selectedDay);
        }).toList();

        return AlertDialog(
          title: Text('Notes on ${DateFormat.yMMMd().format(selectedDay)}'),
          content: dayNotes.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: dayNotes.map((note) {
                    return ListTile(
                      title: Text(note.title ?? 'No Title'),
                      subtitle: Text(
                        note.content ?? 'No Content',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        Get.to(DayEventsScreen(
                          date: selectedDay,
                          notes: dayNotes,
                          eventController: eventController,
                        ));
                      },
                    );
                  }).toList(),
                )
              : Text('No notes for this day.'),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  bool _isSameDayMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void onCellTap(List<CalendarEventData<Object?>> events, DateTime date) {
    // isDay = !isDay;
    // controller.update();
    
    //   notes: notes,
    // ));
  }
}

class DayEventsScreen extends StatelessWidget {
  final DateTime date;
  final List<Note> notes;
  final EventController<Object?> eventController;

  DayEventsScreen({
    required this.date,
    required this.notes,
    required this.eventController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events on ${DateFormat.yMMMd().format(date)}'),
      ),
      body: DayView(
        controller: eventController,
        // fullDayEventBuilder: _fullDayEventBuilder,
        dateStringBuilder: _dateStringBuilder,
        onPageChange: (date, pageIndex) => print("month $date, $pageIndex"),
        onEventTap: (event, date) => print(event),
        onEventDoubleTap: (events, date) => print(events),
        onEventLongTap: (event, date) => print(event),
        onDateLongPress: (date) => print(date),
      ),
    );
  }

  // Widget _fullDayEventBuilder(List<CalendarEventData<Object?>> events, DateTime date) {
  //   return Container(
  //     height: Get.height,width:  Get.width,
  //     child: ListView.builder(
  //       // itemCount: date.day.hours,
  //       itemBuilder: (context, index) {
  //         final event = events[index];
  //         final hour =date.hour[index];
  //         return ListTile(
  //           title: Text(hour),
  //           // subtitle: Text(event.description ?? 'No Description'),
  //         );
  //       },
  //     ),
  //   );
  // }

  String _dateStringBuilder(DateTime date, {DateTime? secondaryDate}) {
    return DateFormat.yMMMd().format(date);
  }
}
// import 'package:calendar_view/calendar_view.dart';
// import 'package:flutter/material.dart';

// import '../extension.dart';
// import 'create_event_page.dart';
