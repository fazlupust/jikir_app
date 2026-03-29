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
              SizedBox(height: 60.h),
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
              SizedBox(height: 40.h),

              // Full Name Field (Only for Signup)
              Obx(() => controller.isLogin.value
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        _buildTextField(
                          hint: "Full Name",
                          controller: controller.fullNameController,
                          icon: Icons.person_outline,
                        ),
                        SizedBox(height: 16.h),
                      ],
                    )),

              // Phone Field
              _buildTextField(
                hint: "Phone Number",
                controller: controller.phoneController,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
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
              
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.card2)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Text("OR", style: TextStyle(color: AppColors.textSecondary, fontSize: 12.sp)),
                  ),
                  Expanded(child: Divider(color: AppColors.card2)),
                ],
              ),
              
              SizedBox(height: 20.h),

              // Google Login Button
              Obx(
                () => controller.isLoading.value
                    ? const SizedBox.shrink()
                    : OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textMain,
                          side: BorderSide(color: AppColors.card2),
                          minimumSize: Size(double.infinity, 54.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        onPressed: controller.loginWithGoogle,
                        icon: Icon(Icons.eighteen_mp),
                        label: Text(
                          "Continue with Google",
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
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
              SizedBox(height: 20.h),
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
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: AppColors.textMain, fontSize: 15.sp),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
        prefixIcon: Icon(icon, color: AppColors.gold, size: 20.sp),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.card,
        contentPadding: EdgeInsets.symmetric(vertical: 18.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r), 
          borderSide: const BorderSide(color: Colors.white24, width: 1.5)
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r), 
          borderSide: const BorderSide(color: Colors.white24, width: 1.5)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r), 
          borderSide: const BorderSide(color: AppColors.gold, width: 2)
        ),
      ),
    );
  }
}

