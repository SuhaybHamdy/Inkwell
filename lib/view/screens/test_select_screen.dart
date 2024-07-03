import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkwell/controllers/note_controller.dart';

typedef OnTimeRangeSelected = void Function(double startHour, double endHour);

class TimeRangeSelector extends StatefulWidget {
  final ScrollController scrollController;
  final OnTimeRangeSelected onTimeRangeSelected;
  double? startHour;
  double? endHour;

  TimeRangeSelector(
      {required this.scrollController,
      required this.onTimeRangeSelected,
      this.startHour,
      this.endHour});

  @override
  _TimeRangeSelectorState createState() => _TimeRangeSelectorState();
}

class _TimeRangeSelectorState extends State<TimeRangeSelector> {
  double startHour = 0.0;
  double endHour = 24.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.endHour != null && widget.startHour != null) {
      startHour = widget.startHour!;
      endHour = widget.endHour!;
    }
    print(
        'this is the reange of the start and end : ${startHour} - ${endHour}');
  }

  void _updateStartHour(double value) {
    setState(() {
      startHour = value.clamp(0.0, 24.0);
      if (startHour >= endHour) {
        endHour = startHour + 1.0;
      }
      widget.onTimeRangeSelected(startHour, endHour);
    });
  }

  void _updateEndHour(double value) {
    setState(() {
      endHour = value.clamp(0.0, 24.0);
      if (endHour <= startHour) {
        startHour = endHour - 1.0;
      }
      widget.onTimeRangeSelected(startHour, endHour);
    });
  }

  void _handleDrag(DragUpdateDetails details) {
    final offset = details.localPosition;
    final totalHeight = context.size!.height;

    if (offset.dy >= 0 && offset.dy <= totalHeight) {
      if (offset.dy <= startHour / 24 * totalHeight + 20 &&
          offset.dy >= startHour / 24 * totalHeight - 20) {
        _updateStartHour(offset.dy / totalHeight * 24);
      } else if (offset.dy <= endHour / 24 * totalHeight + 20 &&
          offset.dy >= endHour / 24 * totalHeight - 20) {
        _updateEndHour(offset.dy / totalHeight * 24);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final NotesController controller = Get.find();

    return
        // controller: widget.scrollController,
        // physics: BouncingScrollPhysics(),
        Container(
      width: MediaQuery.of(context).size.width - 100,
      height: Get.height,
      child: Column(
        children: [
          SizedBox(height: 50),
          SingleChildScrollView(
            // controller: controller.scrollController,
            child: Container(
              height: Get.height - 150,
              child: GestureDetector(
                onDoubleTap: () {
                  controller.unSelectedDate();
                  setState(() {
                    // startHour = 1.0;
                    // endHour = 23.0;
                    widget.onTimeRangeSelected(startHour, endHour);
                  });
                },
                onVerticalDragUpdate: _handleDrag,
                child: Container(
                    child: Stack(
                  children: [
                    ListView.builder(
                        itemCount: endHour.toInt(),
                        itemBuilder: (_, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                height: 26,
                                padding: EdgeInsets.all(0),
                                color: Get.theme.primaryColor.withOpacity(0.3),
                                child: Divider(
                                  color: Get.theme.colorScheme.error,
                                ),
                              ),
                            ],
                          );
                        }),
                    Row(
                      children: [
                        // SizedBox(width: 20,),
                        Container(
                            height: Get.height * 2,
                            // color: Colors.red,
                            child: SingleChildScrollView(
                              controller: controller.scrollController,
                                child: Column(
                              children: [
                                // SizedBox(height: 50,),
                                Container(
                                  height: Get.height * 1.25,
                                  // color: Colors.green,
                                  child: CustomPaint(
                                    size: Size(
                                        MediaQuery.of(context).size.width - 100,
                                        200),
                                    painter: CustomTimeRangePainter(
                                      startHour: startHour,
                                      endHour: endHour,
                                      rangeColor: Colors.blue,
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                )
                              ],
                            ))),
                      ],
                    )
                  ],
                )),
                //
              ),
            ),
          )
        ],
      ),
      // ),
    );
  }
}
// import 'package:flutter/material.dart';

class CustomTimeRangePainter extends CustomPainter {
  final double startHour;
  final double endHour;
  final Color rangeColor;
  final Color backgroundColor;
  final double indicatorRadius;
  final double borderRadius;

  CustomTimeRangePainter({
    required this.startHour,
    required this.endHour,
    required this.rangeColor,
    required this.backgroundColor,
    this.indicatorRadius = 10.0,
    this.borderRadius = 10.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background rectangle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(
        Rect.fromLTWH(0.0, 0.0, size.width, size.height), backgroundPaint);

    // Draw time range rectangle with rounded corners
    final rangePaint = Paint()
      ..color = rangeColor.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    final startY = (startHour / 24) * size.height;
    final endY = (endHour / 24) * size.height;
    final rangeRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0.0, startY, size.width, endY - startY),
      Radius.circular(borderRadius),
    );
    canvas.drawRRect(rangeRect, rangePaint);

    // Draw indicators for start and end time
    final indicatorPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    // Start time indicator
    canvas.drawCircle(
        Offset(size.width / 2, startY), indicatorRadius, indicatorPaint);

    // End time indicator
    canvas.drawCircle(
        Offset(size.width / 2, endY), indicatorRadius, indicatorPaint);

    // Draw start time label
    _drawTimeLabel(canvas, size, startY, startHour, Alignment.topCenter);

    // Draw end time label
    _drawTimeLabel(canvas, size, endY, endHour, Alignment.bottomCenter);
  }

  void _drawTimeLabel(
      Canvas canvas, Size size, double y, double hour, Alignment alignment) {
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 14,
    );
    final time = _formatHour(hour);
    final textSpan = TextSpan(
      text: time,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    double x = size.width / 2 - textPainter.width / 2;
    double textY = alignment == Alignment.topCenter
        ? y - indicatorRadius - 20
        : y + indicatorRadius;

    final offset = Offset(x, textY);
    textPainter.paint(canvas, offset);
  }

  String _formatHour(double hour) {
    final intHour = hour.toInt();
    final intMinute = ((hour - intHour) * 60).toInt();
    final hour12 = intHour % 12 == 0 ? 12 : intHour % 12;
    final amPm = intHour >= 12 ? 'PM' : 'AM';
    return '${hour12.toString().padLeft(2, '0')}:${intMinute.toString().padLeft(2, '0')} $amPm';
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
