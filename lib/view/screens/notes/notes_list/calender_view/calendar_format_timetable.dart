import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkwell/controllers/auth_controller.dart';
import 'package:inkwell/controllers/note_controller.dart';
import 'package:inkwell/routes/app_routes.dart';
import 'package:intl/intl.dart';

import '../../../../../models/note.dart';

Widget buildTimetableView(List<Note> notes) {
  List<Note> sortedNotes =
      notes.where((element) => element.repeatInterval != null).toList()
        ..sort((a, b) {
          DateTime aDate = a.repeatInterval?.startDate ?? DateTime.now();
          DateTime bDate = b.repeatInterval?.startDate ?? DateTime.now();
          return aDate.compareTo(bDate);
        });

  NotesController controller = Get.find();

  Map<String, List<Note>> groupedNotes = {};
  for (var note in sortedNotes) {
    DateTime startDate = note.repeatInterval?.startDate ?? DateTime.now();
    String groupKey = _getGroupKey(startDate);
    if (!groupedNotes.containsKey(groupKey)) {
      groupedNotes[groupKey] = [];
    }
    groupedNotes[groupKey]!.add(note);
  }

  return Scaffold(
    appBar: AppBar(
      title: Text('Timetable View'),
      backgroundColor: Get.theme.colorScheme.primary,
    ),
    body: ListView.builder(
      itemCount: groupedNotes.keys.length,
      itemBuilder: (context, index) {
        String groupKey = groupedNotes.keys.elementAt(index);
        List<Note> notesInGroup = groupedNotes[groupKey]!;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Card(
            elevation: 4.0,
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.tertiary,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    _getGroupHeader(groupKey),
                    style: Get.textTheme.headline6!.copyWith(
                      color: Get.theme.colorScheme.onSecondary,
                    ),
                  ),
                ),
                ...notesInGroup.map((note) {
                  DateTime startDate =
                      note.repeatInterval?.startDate ?? DateTime.now();
                  DateTime endDate = note.repeatInterval?.endDate ??
                      startDate.add(Duration(hours: 1));
                  Color? noteColor = note.color;
                  bool isToday = DateUtils.isSameDay(startDate, DateTime.now());

                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: isToday
                          ? Get.theme.colorScheme.secondary
                          : Colors.transparent,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Indicator circle for today
                        Container(
                          width: isToday ? 14.0 : 10.0,
                          height: isToday ? 14.0 : 10.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: note.color != null ?? isToday
                                ? Get.theme.colorScheme.primary
                                : Get.theme.colorScheme.onBackground,
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.title ?? 'Untitled Note',
                                style: Get.textTheme.titleLarge!.copyWith(
                                    // fontWeight: FontWeight.bold,
                                    color: isToday
                                        ? Get.theme.colorScheme.onPrimary
                                        : Get.theme.colorScheme.primary),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                '${DateFormat.jm().format(startDate)} - ${DateFormat.jm().format(endDate)}',
                                style: Get.textTheme.bodyText2!.copyWith(
                                    color: isToday
                                        ? Get.theme.colorScheme.onPrimary
                                        : Get.theme.colorScheme.primary),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: isToday
                                ? Get.theme.colorScheme.primary
                                : noteColor ?? Get.theme.colorScheme.secondary,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: Get.theme.colorScheme.onPrimary,
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                startDate.day.toString(),
                                style: TextStyle(
                                  color: isToday
                                      ? Get.theme.colorScheme.onPrimary
                                      : Get.theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isToday ? 16.0 : 14.0,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                DateFormat('MMM').format(startDate),
                                style: TextStyle(
                                  color: isToday
                                      ? Get.theme.colorScheme.onPrimary
                                      : Get.theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: isToday ? 12.0 : 10.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    ),
  );
}

String _getGroupKey(DateTime date) {
  DateTime startOfWeek = date.subtract(Duration(days: date.weekday - 1));
  DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

  // Check if the date is within the current week
  if (date.isAfter(startOfWeek) &&
      date.isBefore(endOfWeek.add(Duration(days: 1)))) {
    return 'week-current';
  } else {
    // Group by year, month, and week
    DateFormat weekFormat = DateFormat('yyyy-MM-dd');
    String yearMonth = DateFormat('yyyy-MM').format(date);
    int weekOfMonth = (date.day - 1) ~/ 7 + 1;
    return '$yearMonth-$weekOfMonth';
  }
}

String _getGroupHeader(String groupKey) {
  if (groupKey == 'week-current') {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
    return 'This Week (${DateFormat('MMM dd').format(startOfWeek)} - ${DateFormat('MMM dd').format(endOfWeek)})';
  } else {
    List<String> parts = groupKey.split('-');
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int week = int.parse(parts[2]);

    DateTime firstDayOfMonth = DateTime(year, month, 1);
    DateTime lastDayOfMonth = DateTime(year, month + 1, 0);
    DateTime startOfWeek = firstDayOfMonth.add(Duration(days: (week - 1) * 7));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    String monthYear = DateFormat('MMMM yyyy').format(firstDayOfMonth);

    return '(${DateFormat('MMM dd').format(startOfWeek)} - ${DateFormat('MMM dd').format(endOfWeek)})';
  }
}
