// TODO Implement this library.

// routes/app_pages.dart

import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/note_controller.dart';
import '../view/auth/change_password.dart';
import '../view/auth/forgot_password.dart';
import '../view/auth/login.dart';
import '../view/auth/register.dart';
import '../view/note_edit_screen.dart';
import '../view/note_list_screen.dart';
import '../view/splash_screen.dart';
import 'app_routes.dart';
// Import other screens and their respective controllers

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),

    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => ForgotPasswordScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => ChangePasswordScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),

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
