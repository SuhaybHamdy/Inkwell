import 'local.dart';

class EnTranslations {
  static const Map<String, String> map = {
    // App name
    L10n.nameApp: "Inkwell",

    // Auth screens
    L10n.authScreenLogin: "Login",
    L10n.authScreenSignUp: "Sign Up",
    L10n.authScreenEmail: "Email",
    L10n.authScreenDisplayName: "Display Name", // Name (Arabic)
    L10n.authScreenPassword: "Password",
    L10n.authScreenForgotPassword: "Forgot Password?",
    L10n.authScreenEmailPlaceholder: "Enter your email",
    L10n.authScreenPasswordPlaceholder: "Enter your password",
    // Confirmation (Optional)
    L10n.confirm: "Confirm", // Can be used for password confirmation etc.
    // Login related (optional)
    L10n.alreadyHaveAccount:
        "Already have an account?", // Introductory phrase for login option

    // Note Taking
    L10n.noteTitle: "Title",
    L10n.noteContent: "Content",
    L10n.createNote: "Create Note",
    L10n.editNote: "Edit Note",
    L10n.saveNote: "Save Note",
    L10n.discardNote: "Discard Note",
    L10n.deleteNote: "Delete Note",
    L10n.noteContentPlaceholder: "Start writing your note...",

    // To-Do List
    L10n.taskTitle: "Task Title",
    L10n.taskDescription: "Description (optional)",
    L10n.dueDate: "Due Date",
    L10n.addTask: "Add Task",
    L10n.editTask: "Edit Task",
    L10n.taskDescriptionPlaceholder: "Add a description...",

    // Calendar
    L10n.eventTitle: "Event",
    L10n.allDay: "All Day",
    L10n.addEvent: "Add Event",
    L10n.editEvent: "Edit Event",

    // Reminders (Optional)
    L10n.reminder: "Reminder",
    L10n.addReminder: "Add Reminder",
    L10n.editReminder: "Edit Reminder",

    // Tags (Optional)
    L10n.tagName: "Tag",
    L10n.addTag: "Add Tag",
    L10n.editTag: "Edit Tag",

    // Common phrases
    L10n.yes: "Yes",
    L10n.no: "No",
    L10n.cancel: "Cancel",
  };
}
