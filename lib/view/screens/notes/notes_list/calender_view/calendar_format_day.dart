import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../controllers/note_controller.dart';
import '../../../../../models/note.dart';
import '../../../../../models/schedule.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuildDayView extends GetView<NotesController> {
  final int day = 24;
  final double itemHeight = 50.0;
  final List<Note> notes;

  BuildDayView({
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = itemHeight * day;

    // Generate hours of the day as strings
    List<String> hoursOfDay = List.generate(day, (index) => '${index + 1}:00');

    return Scaffold(
      body: Container(
        height: screenHeight,
        // Ensure the container takes the full height of the screen
        child: Stack(
          children: [
            _buildTheHoursAndEventsOfDay(
              containerHeight: containerHeight,
              hoursOfDay: hoursOfDay,
            ),

            // Placeholder for selected hours view
            _buildTheSelectedHoursOfDay(containerHeight: containerHeight),
          ],
        ),
      ),
    );
  }

  // Widget to build each hour row with events
  Widget _buildHourWithEvents({
    required String hourLabel,
    required List<Note> eventsInHour,
  }) {
    return Container(
      height: itemHeight,
      width: double.infinity,
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            width: 80.0,
            height: itemHeight,
            color: Colors.grey[300],
            child: Text(
              hourLabel,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: itemHeight,
            width: 1,
            color: Colors.black,
          ),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: eventsInHour.length,
              itemBuilder: (context, eventIndex) {
                return _buildEventContainer(eventsInHour[eventIndex]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget to build individual event container
  Widget _buildEventContainer(Note event) {
    Color? eventColor = event.background == null ||
        event.background?.type != 'color'
        ? Colors.blue
        : controller.invertColor(controller.parseColor(event.background!.value));

    return Container(
      height: itemHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: eventColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Event: ${event.title}',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }

  // Widget to build the hours of the day with their corresponding events
  Widget _buildTheHoursAndEventsOfDay({
    required double containerHeight,
    required List<String> hoursOfDay,
  }) {
    return Container(
      height: containerHeight,
      color: Colors.red,
      child: ListView.builder(
        controller: controller.listViewScrollController,
        physics: NeverScrollableScrollPhysics(),
        itemCount: day,
        itemBuilder: (context, index) {
          // Filter events that occur during this hour
          List<Note> eventsInHour = notes.where((note) {
            if (note.repeatInterval != null) {
              DateTime start = note.repeatInterval!.startDate!;
              DateTime end = note.repeatInterval!.endDate!;
              DateTime hourStart = DateTime(2024, 6, 19, index, 0);
              DateTime hourEnd = DateTime(2024, 6, 19, index + 1, 0);
              return start.isBefore(hourEnd) && end.isAfter(hourStart);
            }
            return false;
          }).toList();

          // Build hour row with events
          return _buildHourWithEvents(
            hourLabel: hoursOfDay[index],
            eventsInHour: eventsInHour,
          );
        },
      ),
    );
  }

  // Placeholder widget for selected hours view
  Widget _buildTheSelectedHoursOfDay({required double containerHeight}) {
    return SingleChildScrollView(
      controller: controller.singleChildScrollViewScrollController,
      child: Container(
        height: containerHeight,
        color: Colors.transparent,
        child: Center(child: Text('First Container')),
      ),
    );
  }
}

// class BuildDayView extends GetView<NotesController> {
//   final List<Note> notes;
//
//   const BuildDayView({
//     Key? key,
//     required this.notes,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SizedBox(
//         height: Get.height,
//         width: Get.width,
//         child: Column(
//           children: [
//             // _buildCalendarHeader(), // Optional calendar header
//             Expanded(
//               child: Stack(
//                 children: [
//                   DayView(
//                     key: controller.dayViewKey,
//                     backgroundColor: Get.theme.colorScheme.background,
//                     fullDayEventBuilder: fullDayEventBuilder,
//                     showVerticalLine: true,
//                     // scrollOffset: controller.scrollOffset.value,
//                     controller: controller.eventController,
//                     // liveTimeIndicatorSettings: const LiveTimeIndicatorSettings(
//                     //   color: Colors.redAccent,
//                     //   showTime: true,
//                     // ),
//                     // onDateTap: controller.onDateTap,
//                     // onEventTap: (events, date) {
//                     //   ScaffoldMessenger.of(context).showSnackBar(
//                     //     SnackBar(
//                     //       content: Text('Event Tapped: ${events.first.title}'),
//                     //     ),
//                     //   );
//                     // },
//                     // onEventLongTap: (events, date) {
//                     //   ScaffoldMessenger.of(context).showSnackBar(
//                     //     SnackBar(
//                     //       content: Text('Event Long-Tapped: ${events.first.title}'),
//                     //     ),
//                     //   );
//                     // }
//                   )
// //                 Obx(() {
// //                   if (controller.isDateSelected == true) {
// //                     return Container(
// //                         height: Get.height,
// //                         // top: 0,
// //                         // left: 0,
// //                         // right: 0,
// //                         child: Row(
// //                           children: [
// //                             SizedBox(
// //                               width: 50,
// //                             ),
// //                             TimeRangeSelector(
// //                               scrollController: controller.scrollController,
// //                               onTimeRangeSelected:
// //                                   (double startHour, double endHour) {
// //                                 print(
// //                                     'this is the time range: $startHour - $endHour');
// // // controller.n
// //                               },
// //                               startHour: controller.startHour.value,
// //                               endHour: controller.endHour.value,
// //                             ),
// //                           ],
// //                         ));
// //                   } else {
// //                     return Container();
// //                   }
// //                 }),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCalendarHeader() {
//     DateTime now = DateTime.now();
//     String headerText = DateFormat('EEE, MMM d, yyyy').format(now);
//
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Text(
//         headerText,
//         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
//
//   Widget fullDayEventBuilder(
//       List<CalendarEventData<Object?>> events, DateTime date) {
//     return Container(
//         color: Colors.red,
//         child:
//             // events.length == 0
//             //     ?
//             Container(
//           height: 200,
//           width: Get.width,
//           color: Colors.red,
//           child: Text('full day event is not available ${date.hour}'),
//         )
//         // : ListView.builder(
//         //     itemCount: events.length,
//         //     itemBuilder: (context, index) {
//         //       return Container(
//         //         child: Text(date.hour.toString()),
//         );
//     //     }));
//   }
// }
