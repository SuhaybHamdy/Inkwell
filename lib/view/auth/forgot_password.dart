import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkwell/controllers/auth_controller.dart';
import 'package:inkwell/view/auth/widget/loading_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            Obx(
              () => LoadingButton(
                isLoading: authController.loading.value,
                onPressed: () {
                  authController.forgotPassword(emailController.text);
                },
                text: 'Reset Password',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
