import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/values/app_colors.dart';
import 'package:get/get.dart';
import '../controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Stack(
          children: [
            // Center Logo
            Align(
              alignment: Alignment.center,
              child: Text(
                "ذِكر",
                style: TextStyle(color: AppColors.gold, fontSize: 60.sp),
              ),
            ),
            
            // Bottom Loading and Version
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 24.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 20.w,
                      width: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Obx(() => Text(
                      controller.appVersion.value.isEmpty ? "Loading..." : controller.appVersion.value,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 15.sp, letterSpacing: 2),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
