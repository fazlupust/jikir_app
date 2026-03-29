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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "ذِكر",
              style: TextStyle(color: AppColors.gold, fontSize: 60.sp),
            ),
            const Spacer(),
            Text(
              "Version 1.0.1",
              style: TextStyle(color: Colors.white24, fontSize: 12.sp),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
