import 'package:flutter/material.dart';
import 'package:get/get.dart';


// selected date for the add or edit widget
Future<void> selectDate(
    Rx<DateTime> dateTime, Function(DateTime) onDateChanged) async
{
  DateTime? picked = await showDatePicker(
    context: Get.context!,
    initialDate: dateTime.value,
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );
  if (picked != null) onDateChanged(picked);
}