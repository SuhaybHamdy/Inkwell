import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:inkwell/view/note_list_screen.dart';
import 'routes/app_routes.dart';
import 'routes/app_pages.dart';

import 'controllers/note_controller.dart';
import 'firebase_options.dart';
// routes/app_pages.dart

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    Get.lazyPut(()=>NoteController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xffF4E1A0),
            background: Color(0xff00000),
            brightness: Brightness.dark),
        useMaterial3: true,
      ),
      // home: NoteListScreen(),
      initialRoute: AppRoutes.noteList,
      getPages: AppPages.pages,
    );
  }
}
