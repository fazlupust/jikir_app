import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/category_header_widget.dart';
import 'widgets/counter_circle_widget.dart';
import 'widgets/home_action_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 60.h),
        const CategoryHeaderWidget(),
        const Spacer(),
        const CounterCircleWidget(),
        const Spacer(),
        const HomeActionBar(),
        SizedBox(height: 60.h),
      ],
    );
  }
}
