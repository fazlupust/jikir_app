import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/values/app_colors.dart';
import '../../controller/home_controller.dart';

class CounterCircleWidget extends GetWidget<HomeController> {
  const CounterCircleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.onIncrement,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 260.w,
        height: 260.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.card,
          border: Border.all(color: AppColors.gold.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withOpacity(0.05),
              blurRadius: 50,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Obx(
            () => Text(
              "${controller.count.value}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 80.sp,
                fontFamily: 'Cinzel',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
