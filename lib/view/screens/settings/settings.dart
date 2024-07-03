import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Theme',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Obx(() => RadioListTile<ThemeMode>(
                  title: const Text('Light Theme'),
                  value: ThemeMode.light,
                  groupValue: themeController.themeMode.value,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      themeController.setThemeMode(value);
                    }
                  },
                )),
            Obx(() => RadioListTile<ThemeMode>(
                  title: const Text('Dark Theme'),
                  value: ThemeMode.dark,
                  groupValue: themeController.themeMode.value,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      themeController.setThemeMode(value);
                    }
                  },
                )),
            Obx(() => RadioListTile<ThemeMode>(
                  title: const Text('System Theme'),
                  value: ThemeMode.system,
                  groupValue: themeController.themeMode.value,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      themeController.setThemeMode(value);
                    }
                  },
                )),
            ListTile(
              title: const Text('Night Theme'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _showNightModePicker(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNightModePicker(BuildContext context) {
    final ThemeController themeController = Get.find();
    final startTimeController = TextEditingController(
        text: TimeOfDay.fromDateTime(DateTime.now()).format(context));

    final endTimeController = TextEditingController(
      text: themeController.nightModeEndTime.value.format(context),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Night Mode Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: startTimeController,
                readOnly: true,
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    startTimeController.text = picked.format(context);
                    themeController.setNightModeStartTime(picked);
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Start Time',
                  suffixIcon: Icon(Icons.access_time),
                ),
              ),
              TextField(
                controller: endTimeController,
                readOnly: true,
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    endTimeController.text = picked.format(context);
                    themeController.setNightModeEndTime(picked);
                  }
                },
                decoration: InputDecoration(
                  labelText: 'End Time',
                  suffixIcon: Icon(Icons.access_time),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Validate user input before updating night mode times
                if (_validateTimeInput(
                    startTimeController.text, endTimeController.text)) {
                  final startTime = TimeOfDay.fromDateTime(
                      DateTime.parse(startTimeController.text));
                  final endTime = TimeOfDay.fromDateTime(
                      DateTime.parse(endTimeController.text));

                  // Update night mode times and apply theme
                  themeController.setNightModeStartTime(startTime);
                  themeController.setNightModeEndTime(endTime);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  bool _validateTimeInput(String startTimeText, String endTimeText) {
    try {
      final startTime = TimeOfDay.fromDateTime(DateTime.parse(startTimeText));
      final endTime = TimeOfDay.fromDateTime(DateTime.parse(endTimeText));

      // Validate if start time is before end time
      if (startTime.hour >= endTime.hour && startTime.minute > endTime.minute) {
        // Show error message (e.g., using a snackbar or dialog)
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('Start time must be before end time.'),
          ),
        );
        return false;
      }

      return true; // Valid input
    } catch (e) {
      // Handle parsing errors (e.g., show error message)
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text('Invalid time format. Please use HH:mm'),
        ),
      );
      return false;
    }
  }

  void _updateThemeBasedOnTime(
      TimeOfDay startTime, TimeOfDay endTime, ThemeController themeController) {
    // Check if current time falls within night mode based on updated times
    final currentTime = TimeOfDay.now();
    if (themeController.isDarkMode) {
      themeController.setThemeMode(ThemeMode.dark);

      // Get.changeTheme(themeController.me.dark());
    } else {
      themeController.setThemeMode(ThemeMode.light);

      // Get.changeTheme(themeController.theme.light());
    }
  }
}
