// import 'dart:io';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:inkwell/local/en.dart';
import 'package:inkwell/local/ar.dart';
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

  // Calendar
  static const String eventTitle = "Event";
  static const String allDay = "All Day";
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
}
