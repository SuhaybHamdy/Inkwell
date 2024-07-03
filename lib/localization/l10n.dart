// import 'dart:io';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:inkwell/localization/en.dart';
import 'package:inkwell/localization/ar.dart';
import 'local.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': EnTranslations.map,
        'ar': ArTranslations.map,
      };

  static List<Locale> supportedLocales() {
    final appTranslations = AppTranslations();
    return appTranslations.keys.keys.map((language) {
      final List<String> parts = language.split('_');
      return Locale(parts[0], parts.length > 1 ? parts[1] : '');
    }).toList();
  } // Reverse translation method
}

class L10n {
  static const String nameApp = "Inkwell"; // App name

  // Auth screens (add placeholders for placeholders)
  static const String authScreenLogin = "Login";
  static const String authScreenSignUp = "Sign Up";
  static const String authScreenEmail = "Email";
  static const String authScreenDisplayName = "DisplayName";
  static const String authScreenPassword = "Password";
  static const String authScreenForgotPassword = "Forgot Password?";
  static const String authScreenEmailPlaceholder = "Enter your email";
  static const String authScreenPasswordPlaceholder = "Enter your password";

  // Confirmation (optional)
  static const String confirm =
      "Confirm"; // Can be used for password confirmation etc.

  // Login related (optional)
  static const String alreadyHaveAccount =
      "Already have an account?"; // Introductory phrase for login option

  // Note Taking
  static const String noteTitle = "Title";
  static const String noteContent = "Content";
  static const String createNote = "Create Note";
  static const String editNote = "Edit Note"; // Add for edit mode
  static const String saveNote = "Save Note";
  static const String discardNote = "Discard Note";
  static const String deleteNote = "Delete Note";
  static const String noteContentPlaceholder =
      "Start writing your note..."; // Placeholder for add mode

  // To-Do List
  static const String taskTitle = "Task Title";
  static const String taskDescription = "Description (optional)";
  static const String dueDate = "Due Date";
  static const String addTask = "Add Task"; // Add for add mode
  static const String editTask = "Edit Task"; // Add for edit mode
  static const String taskDescriptionPlaceholder =
      "Add a description..."; // Placeholder for add mode

  // Note edit form
  static const String addTitle = "Add Title";
  static const String save = "Save";
  static const String timing = "Timing";
  static const String allDay = "All day";
  static const String start = "Start";
  static const String end = "End";
  static const String timezone = "Timezone";
  static const String noRepeat = "No repeat";
  static const String addInvitees = "Add invitees";
  static const String addVideoConference = "Add video conference";
  static const String addLocation = "Add location";
  static const String addDescription = "Add description";
  static const String addAttachments = "Add attachments";

  // Calendar
  static const String eventTitle = "Event";
  static const String addEvent = "Add Event"; // Add for add mode
  static const String editEvent = "Edit Event"; // Add for edit mode

  // Reminders (Optional)
  static const String reminder = "Reminder";
  static const String addReminder = "Add Reminder"; // Add for add mode
  static const String editReminder = "Edit Reminder"; // Add for edit mode

  // Tags (Optional)
  static const String tagName = "Tag";
  static const String addTag = "Add Tag";
  static const String editTag = "Edit Tag"; // Add for edit mode

  // Common phrases
  static const String yes = "Yes";
  static const String no = "No";
  static const String cancel = "Cancel";

  // RepeatOption
  static const String repeatNever = "daily";
  static const String repeatDaily = "never";
  static const String repeatWeekly = "weekly";
  static const String repeatMonthlyByDay = "monthlyByDay";
  static const String repeatMonthlyByDate = "monthlyByDate";
  static const String repeatYearly = "yearly";
  static const String repeatCustom = "custom";

  // WeekDay
  static const String monday = "monday";
  static const String tuesday = "tuesday";
  static const String wednesday = "wednesday";
  static const String thursday = "thursday";
  static const String friday = "friday";
  static const String saturday = "saturday";
  static const String sunday = "sunday";

  // CustomInterval
  static const String customWeek = "day";
  static const String customDay = "week";
  static const String customMonthDay = "monthDay";
  static const String customMonthDate = "monthDate";
  static const String customYear = "year";

  static const String repeatOptions = "Repeat Options";
  static const String customInterval = "Custom Interval";
  static const String selectWeekdays = "Select Weekdays";
  static const String customDates = "Custom Dates";
  static const String repeatOption = "Repeat Option";
  static const String intervalValue = "Interval Value";
  static const String startDate = "Select Start Date";
  static const String endDate = "Select End Date";
  static const String withoutEndDate = "Without End Date";
  static const String saveSchedule = "Save Schedule";

  // Category
  static const String category = 'Category';
  static const String selectCategory = 'Select Category';

  static const String personal = 'Personal';
  static const String work = 'Work';
  static const String shopping = 'Shopping';
  static const String ideas = 'Ideas';
  static const String travel = 'Travel';
  static const String finance = 'Finance';
  static const String health = 'Health';
  static const String food = 'Food';
  static const String learning = 'Learning';
  static const String events = 'Events';

  static const String color = 'color';


  static const String checklist = 'checklist';
  static const String addItem = 'addItem';
  static const String addChecklistItem = 'addChecklistItem';
  static const String priority = 'priority';
  static const String attachments = 'attachments';
  static const String addAttachment = 'addAttachment';
  static const String important = 'important';
  static const String hint = 'hint';





}
