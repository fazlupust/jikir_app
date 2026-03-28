import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/values/app_colors.dart';
import '../../controller/home_controller.dart';

class HomeActionBar extends GetWidget<HomeController> {
  const HomeActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 60.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildToolButton(
            icon: Icons.refresh_rounded,
            onPressed: () => _confirmReset(),
          ),
          _buildToolButton(
            icon: Icons.format_list_bulleted_rounded,
            onPressed: () {
              // Trigger category selection sheet
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.card2, width: 2),
        ),
        child: Icon(icon, color: AppColors.textSecondary, size: 24.sp),
      ),
    );
  }

  void _confirmReset() {
    Get.defaultDialog(
      title: "Reset",
      middleText: "Restart today's count?",
      backgroundColor: AppColors.card,
      titleStyle: const TextStyle(color: AppColors.gold),
      middleTextStyle: const TextStyle(color: Colors.white70),
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.black,
      buttonColor: AppColors.gold,
      onConfirm: () {
        controller.count.value = 0;
        Get.back();
      },
    );
  }
}
