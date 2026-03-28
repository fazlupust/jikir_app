import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/values/app_colors.dart';
import '../controller/auth_controller.dart';

class AuthScreen extends GetView<AuthController> {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 80.h),
              // Logo/Icon
              Text(
                "ذِكر",
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 64.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Amiri', // Matching your HTML font
                ),
              ),
              SizedBox(height: 10.h),
              Obx(
                () => Text(
                  controller.isLogin.value ? "Welcome Back" : "Create Account",
                  style: TextStyle(color: AppColors.textMain, fontSize: 18.sp),
                ),
              ),
              SizedBox(height: 50.h),

              // Email Field
              _buildTextField(
                hint: "Email Address",
                controller: controller.emailController,
                icon: Icons.email_outlined,
              ),
              SizedBox(height: 16.h),

              // Password Field
              Obx(
                () => _buildTextField(
                  hint: "Password",
                  controller: controller.passwordController,
                  icon: Icons.lock_outline,
                  isPassword: true,
                  obscureText: !controller.isPasswordVisible.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.textSecondary,
                      size: 20.sp,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
              ),

              SizedBox(height: 30.h),

              // Submit Button
              Obx(
                () => controller.isLoading.value
                    ? const CircularProgressIndicator(color: AppColors.gold)
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          foregroundColor: Colors.black,
                          minimumSize: Size(double.infinity, 54.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        onPressed: controller.submit,
                        child: Text(
                          controller.isLogin.value ? "LOGIN" : "SIGN UP",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),

              SizedBox(height: 20.h),

              // Toggle Auth Mode
              TextButton(
                onPressed: controller.toggleAuthMode,
                child: Obx(
                  () => RichText(
                    text: TextSpan(
                      text: controller.isLogin.value
                          ? "New here? "
                          : "Have an account? ",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14.sp,
                      ),
                      children: [
                        TextSpan(
                          text: controller.isLogin.value
                              ? "Create Account"
                              : "Login Now",
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.card2, width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: AppColors.textMain, fontSize: 15.sp),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
          prefixIcon: Icon(icon, color: AppColors.gold, size: 20.sp),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18.h),
        ),
      ),
    );
  }
}
