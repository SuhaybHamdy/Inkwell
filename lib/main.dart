import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:inkwell/controllers/auth_controller.dart';
import 'package:inkwell/localization/local.dart';
import 'package:inkwell/routes/app_routes.dart';
import 'package:inkwell/routes/app_pages.dart';
import 'package:inkwell/theme/theme.dart';
import 'package:inkwell/theme/util.dart';
import 'controllers/theme_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AuthController());
    Get.put(ThemeController()); // Add ThemeController

    return GetBuilder<ThemeController>(
      builder: (themeController) {
        final brightness = View.of(context).platformDispatcher.platformBrightness;
        TextTheme textTheme = createTextTheme(context, "Allerta", "Akaya Kanadaka");
        MaterialTheme theme = MaterialTheme(textTheme);

        return GetMaterialApp(

          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: theme.lightHighContrast(),
          // darkTheme: theme.dark(),
          // themeMode: themeController.themeMode.value,
          translations: AppTranslations(),
          localizationsDelegates: const [
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ],
          locale: Locale(Get.find<AuthController>().getLangCode, ''),
          initialRoute: AppRoutes.splash,
          getPages: AppPages.pages,
        );
      },
    );
  }
}


