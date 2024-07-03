import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';

import '../../../../controllers/note_controller.dart';
import '../../../../models/note.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../theme/util.dart';
import 'calender_view/calendar_format_day.dart';
import 'calender_view/calendar_format_month.dart';
import 'calender_view/calendar_format_three_days.dart';
import 'calender_view/calendar_format_timetable.dart';
import 'calender_view/calendar_format_week.dart';

class NoteCalendarView extends StatelessWidget {
  final List<Note> notes;
  final NotesController controller;

  NoteCalendarView({required this.notes, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          // _buildViewModeToggle(),
          // _buildCalendarHeader(),

          Expanded(
            child: _buildCalendarBody(),
          ),
        ],
      );
    });
  }

  Widget _buildCalendarHeader() {
    DateTime now = DateTime.now();
    String headerText;

    switch (controller.calendarFormat.value) {
      case CustomCalendarFormat.cityView:
        headerText = 'City View';
        break;
      case CustomCalendarFormat.day:
        headerText = DateFormat('EEE, MMM d, yyyy').format(now);
        break;
      // case CustomCalendarFormat.threeDays:
      //   headerText = DateFormat('EEE, MMM d').format(now) +
      //       ' - ' +
      //       DateFormat('EEE, MMM d').format(now.add(const Duration(days: 2)));
      //   break;
      case CustomCalendarFormat.week:
        headerText = DateFormat('EEE, MMM d').format(now) +
            ' - ' +
            DateFormat('EEE, MMM d').format(now.add(Duration(days: 6)));
        break;

      case CustomCalendarFormat.month:
      default:
        headerText = DateFormat('MMMM yyyy').format(now);
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        headerText,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCalendarBody() {
    switch (controller.calendarFormat.value) {
      case CustomCalendarFormat.cityView:
        return buildTimetableView(notes);
      case CustomCalendarFormat.day:
        return BuildDayView(notes: notes,);

      case CustomCalendarFormat.week:
        return buildTimetableView(notes);

      case CustomCalendarFormat.month:
        return BuildMonthView(notes: notes,);
      // case CustomCalendarFormat.threeDays:
      //   return buildThreeDayView(notes);

      default:
        return BuildMonthView(notes: notes,);
    }
  }


  // Widget _buildTimetableView() {
  //   // Implement a custom city view
  //   return Text('Building City View ');
  //
  // }

  Widget _buildViewModeToggle() {
    return Container(
      height: Get.height,width: Get.width,
      color: Colors.cyan,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: GetBuilder<NotesController>(
          builder: (controller) {
            return ToggleButtons(
              color: Get.theme.colorScheme.primary,
              isSelected: [
                controller.calendarFormat.value == CustomCalendarFormat.cityView,

                controller.calendarFormat.value == CustomCalendarFormat.day,
                // controller.calendarFormat.value == CustomCalendarFormat.threeDays,
                controller.calendarFormat.value == CustomCalendarFormat.week,
                controller.calendarFormat.value == CustomCalendarFormat.month,
              ],
              onPressed: (int index) {
                switch (index) {

                  case 0:
                    controller.changeCalendarFormat(CustomCalendarFormat.cityView);
                    break;
                  case 1:
                    controller.changeCalendarFormat(CustomCalendarFormat.day);
                    break;
                  // case 2:
                  //   controller.changeCalendarFormat(CustomCalendarFormat.threeDays);
                  //   break;
                  case 2:
                    controller.changeCalendarFormat(CustomCalendarFormat.week);
                    break;
                  case 3:
                    controller.changeCalendarFormat(CustomCalendarFormat.month);
                    break;

                }
              },
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('City View'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Day'),
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 16),
                //   child: Text('3 Days'),
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Week'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Month'),
                ),

              ],
            );
          },
        ),
      ),
    );
  }
}
