import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkwell/controllers/auth_controller.dart';
import 'package:inkwell/view/auth/register.dart';
import 'package:inkwell/view/auth/widget/loading_button.dart';

import '../../localization/local.dart';
import 'forgot_password.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.authScreenLogin.tr), // Use L10n.authScreenLogin for "Login"
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: L10n.authScreenEmail.tr), // Use L10n.authScreenEmail for "Email"
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: L10n.authScreenPassword.tr, // Use L10n.authScreenPassword for "Password"
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Obx(
              () => LoadingButton(
                isLoading: authController.loading.value,
                onPressed: () {
                  authController.login(
                      emailController.text, passwordController.text);
                },
                text: L10n.authScreenLogin.tr, // Use L10n.authScreenLogin for "Login" (again)
              ),
            ),
            TextButton(
              onPressed: () => Get.to(RegisterScreen()),
              child: Text(L10n.authScreenSignUp.tr), // Use L10n.authScreenSignUp for "Register"
            ),
            TextButton(
              onPressed: () => Get.to(ForgotPasswordScreen()),
              child: Text(L10n.authScreenForgotPassword.tr), // Use L10n.authScreenForgotPassword for "Forgot Password"
            ),
          ],
        ),
      ),
    );
  }
}
