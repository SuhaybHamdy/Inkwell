import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkwell/controllers/auth_controller.dart';
import 'package:inkwell/view/auth/widget/loading_button.dart';

import '../../localization/local.dart';

class RegisterScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.authScreenSignUp.tr), // Use L10n.authScreenSignUp for "Sign Up"
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: L10n.authScreenEmail.tr, // Use L10n.authScreenEmail for "Email"
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: displayNameController,
                decoration:  InputDecoration(labelText: L10n.authScreenDisplayName.tr),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: L10n.authScreenPassword.tr, // Use L10n.authScreenPassword for "Password"
                ),
                obscureText: true,
              ),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: "${L10n.authScreenPassword.tr} ${L10n.confirm.tr}", // Use L10n.authScreenPassword for "Password" and L10n.confirm for "Confirm"
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Obx(() {
                return LoadingButton(
                  isLoading: authController.loading.value,
                  onPressed: () {
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();
                    String confirmPassword = confirmPasswordController.text.trim();
                    String displayName = displayNameController.text.trim();
          
                    authController.register(email, password, confirmPassword, displayName);
                  },
                  text: L10n.authScreenSignUp.tr, // Use L10n.authScreenSignUp for "Register"
                );
              }),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Get.toNamed('/login'); // Navigate to login screen
                },
                child: Text(L10n.alreadyHaveAccount.tr + ' ' + L10n.authScreenLogin.tr), // Use L10n.alreadyHaveAccount for "Already have an account?" and L10n.login for "Login"
              ),
            ],
          ),
        ),
      ),
    );
  }
}
