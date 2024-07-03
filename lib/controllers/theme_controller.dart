import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/util.dart';
import '../theme/theme.dart';

class ThemeController extends GetxController {
  var themeMode = ThemeMode.light.obs;
  var nightModeStartTime = TimeOfDay(hour: 23, minute: 0).obs; // Default start time for night mode
  var nightModeEndTime = TimeOfDay(hour: 7, minute: 0).obs; // Default end time for night mode

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
        _updateTheme();

  }

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    _updateTheme();
  }

  void setNightModeStartTime(TimeOfDay time) {
    nightModeStartTime.value = time;
    _updateTheme();
  }

  void setNightModeEndTime(TimeOfDay time) {
    nightModeEndTime.value = time;
    _updateTheme();
  }
// ThemeData themeData;
  void _updateTheme() {
    TextTheme textTheme =
        createTextTheme(Get.context!, "Allerta", "Akaya Kanadaka");
    MaterialTheme theme = MaterialTheme(textTheme);
    if (isNightTime||isDarkMode==true||themeMode.value.name=='dark') {
      Get.changeTheme(theme.dark());
    } else {
      Get.changeTheme(theme.light());
    }
  }

  bool get isDarkMode => themeMode.value == ThemeMode.dark;

bool get isNightTime {
  final currentTime = TimeOfDay.now();
  final startTime = TimeOfDay(hour: nightModeStartTime.value.hour, minute: nightModeStartTime.value.minute);
  final endTime = TimeOfDay(hour: nightModeEndTime.value.hour, minute: nightModeEndTime.value.minute);

  if (startTime.hour < endTime.hour) {
    return currentTime.hour >= startTime.hour && currentTime.hour < endTime.hour;
  } else {
    return currentTime.hour >= startTime.hour || currentTime.hour < endTime.hour;
  }
}
}
