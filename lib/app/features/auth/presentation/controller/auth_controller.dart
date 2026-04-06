import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repository/auth_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  final AuthRepositoryImpl authRepository;

  AuthController(this.authRepository);

  var isLogin = true.obs;
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();

  void toggleAuthMode() => isLogin.value = !isLogin.value;
  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  Future<void> submit() async {
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final fullName = fullNameController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Phone and password are required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.scaffoldBackgroundColor,
      );
      return;
    }

    if (!isLogin.value && fullName.isEmpty) {
      Get.snackbar(
        "Error",
        "Full name is required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.scaffoldBackgroundColor,
      );
      return;
    }

    isLoading.value = true;
    try {
      if (isLogin.value) {
        await authRepository.loginWithPhonePassword(phone, password);
      } else {
        await authRepository.signUpWithPhonePassword(fullName, phone, password);
      }
      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Auth Failed",
        e.message ?? "An error occurred",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.scaffoldBackgroundColor,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.scaffoldBackgroundColor,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    try {
      final userCredential = await authRepository.signInWithGoogle();
      if (userCredential != null) {
        Get.offAllNamed('/home');
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Google Login Failed",
        e.message ?? "An error occurred",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.scaffoldBackgroundColor,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.scaffoldBackgroundColor,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    super.onClose();
  }
}
