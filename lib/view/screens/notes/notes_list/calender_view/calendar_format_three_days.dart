import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../models/note.dart';

Widget buildThreeDayView(List<Note> notes) {
  EventController<Object?> eventController = EventController<Object?>();

  for (var note in notes) {
    eventController.add(CalendarEventData(
        event: note,
        title: note.title ?? 'No Title',
        description: note.content ?? 'No Content',
        date:  note.lastEdited ?? DateTime.now(),
        startTime: note.repeatInterval?.startDate,
        endDate: note.repeatInterval?.endDate
    ));
  }

  return Scaffold(
    appBar: AppBar(
      title: Text('Three-Day View'),
    ),
    body: WeekView(
      controller: eventController,
     
      // initialDay: DateTime.now(),/**/
      pageTransitionDuration: Duration(milliseconds: 300),
      pageTransitionCurve: Curves.ease,
      // heightPerMinute: 1,
      // timeLineOffset: 5,
      // showLiveTimeLineInAllDays: true,
      // showVerticalLines: true,
      // weekDays: [
      //   WeekDays.monday,
      //   WeekDays.tuesday,
      //   WeekDays.wednesday,
      // ],
      // showWeekends: false,
      // startDay: WeekDays.monday,
      // timeLineBuilder: (time) => Text(DateFormat.Hm().format(time)),
      // dayTitleBuilder: (date) => Center(child: Text(DateFormat.E().format(date))),
      onEventTap: (events, date) {

        ScaffoldMessenger.of(
          Get.context!).showSnackBar(
          SnackBar(content: Text("Event Tapped: ${events.first.title}")),
        );
      },
      onEventLongTap: (events, date) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text("Event Long-Tapped: ${events.first.title}")),
        );
      },
      liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
        color: Colors.redAccent,
        showTime: true,
      ),
      headerStyle: HeaderStyle(
        headerMargin: EdgeInsets.all(8),
        headerTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      scrollOffset: 0.0,
      startHour: 0,
      endHour: 24,
      showHalfHours: true,
      showQuarterHours: false,
    ),
  );
}
