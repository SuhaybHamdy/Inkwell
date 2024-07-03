import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkwell/models/user.dart';
import 'package:inkwell/services/auth_service.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  Rx<UserModel?> currentUser = Rx(null); // Use Rx<UserModel?> to store user data
  RxBool isAuth = false.obs;
  RxBool loading = false.obs;

  String getLangCode = 'ar';

  @override
  void onInit() {
    super.onInit();
    // checkAuthStatus(); // Check auth status on initialization
  }

  // Check if the user is authenticated
  Future<void> checkAuthStatus() async {
    String? token = await _authService.getAuthToken();

    if (token != null && token.isNotEmpty) {
      User? firebaseUser = _authService.getCurrentUser();
      if (firebaseUser != null) {
        currentUser.value = await _authService.fetchUserData(firebaseUser.uid);
        isAuth.value = true;
        Get.offNamed(AppRoutes.noteList);
      } else {
        isAuth.value = false;
        Get.offNamed(AppRoutes.login);
      }
    } else {
      isAuth.value = false;
      Get.offNamed(AppRoutes.login);
    }
  }

  // Login method
  Future<void> login(String email, String password) async {
    try {
      loading.value = true;
      UserCredential userCredential = await _authService.login(email, password);

      String? token = await userCredential.user!.getIdToken();
      await _authService.saveAuthToken(token!);

      currentUser.value = await _authService.fetchUserData(userCredential.user!.uid);

      isAuth.value = true;
      Get.offAllNamed(AppRoutes.noteList);
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor:Colors.red );
    } finally {
      loading.value = false;
    }
  }

  // Register method with additional user details
  Future<void> register(String email, String password, String confirmPassword, String displayName) async {
    if (password != confirmPassword) {
      Get.snackbar('Error', 'Passwords d, backgroundColor:Colors.red o not match');
      return;
    }
    try {
      loading.value = true;
      UserCredential userCredential = await _authService.register(email, password);

      UserModel newUser = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        displayName: displayName,
        createdAt: DateTime.now(),
      );

      await _authService.saveUserData(newUser);

      String? token = await userCredential.user!.getIdToken();
      await _authService.saveAuthToken(token!);

      currentUser.value = newUser;
      isAuth.value = true;
      Get.offAllNamed(AppRoutes.noteList);
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor:Colors.red );
    } finally {
      loading.value = false;
    }
  }

  // Forgot password method
  Future<void> forgotPassword(String email) async {
    try {
      loading.value = true;
      await _authService.sendPasswordResetEmail(email);
      Get.snackbar('Success', 'Password reset email sent');
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor:Colors.red );
    } finally {
      loading.value = false;
    }
  }

  // Change password method
  Future<void> changePassword(String oldPassword, String newPassword, String confirmPassword) async {
    if (newPassword != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match',backgroundColor:Colors.red);
      return;
    }
    try {
      loading.value = true;
      User user = _authService.getCurrentUser()!;
      await _authService.reauthenticate(user, oldPassword);
      await _authService.updatePassword(user, newPassword);
      Get.snackbar('Success', 'Password updated');
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor:Colors.red );
    } finally {
      loading.value = false;
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      loading.value = true;
      await _authService.signOut();
      currentUser.value = null;
      isAuth.value = false;
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      Get.snackbar('Error', 'Logout fail, backgroundColor:Colors.red ed: $e');
    } finally {
      loading.value = false;
    }
  }
}
