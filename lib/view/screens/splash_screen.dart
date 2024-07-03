import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkwell/controllers/auth_controller.dart';
import 'package:inkwell/routes/app_routes.dart';

import '../../controllers/theme_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  final AuthController authController = Get.find<AuthController>();
  final ThemeController themeController = Get.find<ThemeController>();

  Widget build(BuildContext context) {
    authController.checkAuthStatus();
    setState(() {
      themeController.addListener(() {
        Get.isDarkMode;
        // themeController.update();
      });
    });
    return GetBuilder<ThemeController>(
      builder: (controller) {

        return Container();
      },
    );
  }
}

// class SplashScreen extends StatelessWi 
/*dget {
  final AuthController authController = Get.find<AuthController>();

  SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    authController.checkAuthStatus();
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
*/