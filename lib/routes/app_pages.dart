// TODO Implement this library.

// routes/app_pages.dart

import 'package:get/get.dart';
import '../controllers/note_controller.dart';
import '../view/note_edit_screen.dart';
import '../view/note_list_screen.dart';
import 'app_routes.dart';
// Import other screens and their respective controllers

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.noteList,
      page: () => NoteListScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<NoteController>(() => NoteController());
      }),
    ), GetPage(
      name: AppRoutes.noteDetail,
      page: () => NoteEditScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<NoteController>(() => NoteController());
      }),
    ),



    // Add more GetPage entries for other routes and their bindings
    // Example:
    // GetPage(
    //   name: AppRoutes.noteDetail,
    //   page: () => NoteDetailScreen(),
    //   binding: BindingsBuilder(() {
    //     Get.lazyPut<NoteDetailController>(() => NoteDetailController());
    //   }),
    // ),
  ];
}
