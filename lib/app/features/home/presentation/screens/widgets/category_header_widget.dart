import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/values/app_colors.dart';
import '../../controller/home_controller.dart';

class CategoryHeaderWidget extends GetWidget<HomeController> {
  const CategoryHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Text(
            controller.currentCategoryName.value.toUpperCase(),
            style: TextStyle(
              color: AppColors.gold,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 5,
              fontFamily: 'Cinzel',
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.card2,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            "DAILY TARGET",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10.sp,
              letterSpacing: 2,
            ),
          ),
        ),
      ],
    );
  }
}
