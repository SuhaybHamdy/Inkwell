import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:inkwell/controllers/auth_controller.dart';
import 'package:inkwell/local/local.dart';
import 'routes/app_routes.dart';
import 'routes/app_pages.dart';

import 'firebase_options.dart';
import 'package:inkwell/theme/theme.dart';
import 'package:inkwell/theme/util.dart';

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
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    //
    // // Retrieves the default theme for the platform
    // TextTheme textTheme = Theme.of(context).textTheme;
    //
    // // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Allerta", "Akaya Kanadaka");
    //
    MaterialTheme theme = MaterialTheme(textTheme);

    Get.lazyPut(()=>AuthController());
return GetBuilder<AuthController>(
  builder: (controller) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      translations: AppTranslations(),
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      locale: Locale(controller.getLangCode, ''),
      // fallbackLocale: Locale(LangCode.en.name, ''),

      // useMaterial3: true,
      // ),
      // home: LoginScreen(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  },
) ; }
}
