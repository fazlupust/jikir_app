import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../controller/home_controller.dart';
import 'counter_screen.dart';
import 'history_screen.dart';
import 'stats_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final appColors = context.appColors;
      final navTheme = Theme.of(context).bottomNavigationBarTheme;

      return Scaffold(
        backgroundColor: appColors.bg,
        appBar: AppBar(
          backgroundColor: appColors.surf,
          elevation: 0,
          toolbarHeight: 60,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ذِكر", style: context.arabicText.copyWith(fontSize: 28, color: appColors.gold, height: 1)),
                  Text("Dhikr Counter", style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 10, letterSpacing: 4, color: appColors.txt2, height: 1.2
                  )),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(DateFormat('MMM dd, yyyy').format(DateTime.now()), 
                    style: TextStyle(fontSize: 12, color: appColors.gold, fontWeight: FontWeight.bold)
                  ),
                  Text(DateFormat('EEEE').format(DateTime.now()), 
                    style: TextStyle(fontSize: 11, color: appColors.txt2)
                  ),
                ],
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: appColors.bdr, height: 1),
          ),
        ),
        body: IndexedStack(
          index: controller.currentTab.value,
          children: [
            const CounterScreen(),
            const HistoryScreen(),
            const StatsScreen(),
            const ProfileScreen(),
            const SettingsScreen(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: appColors.bdr, width: 1)),
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentTab.value,
            onTap: controller.onTabChanged,
            type: BottomNavigationBarType.fixed,
            backgroundColor: appColors.surf,
            selectedItemColor: appColors.gold,
            unselectedItemColor: appColors.white,
            selectedFontSize: 13,
            unselectedFontSize: 13,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.touch_app_outlined,color: Colors.white), // Simplified for now, need custom or appropriate icons
                activeIcon: _activeIcon(Icons.touch_app_outlined, appColors.gold),
                label: 'Counter'.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_outlined,color: Colors.white),
                activeIcon: _activeIcon(Icons.calendar_today_outlined, appColors.gold),
                label: 'History'.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_outlined,color: Colors.white),
                activeIcon: _activeIcon(Icons.bar_chart_outlined, appColors.gold),
                label: 'Stats'.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline,color: Colors.white),
                activeIcon: _activeIcon(Icons.person_outline, appColors.gold),
                label: 'Profile'.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined,color: Colors.white),
                activeIcon: _activeIcon(Icons.settings_outlined, appColors.gold),
                label: 'Settings'.tr,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _activeIcon(IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24, height: 2,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(3), bottomRight: Radius.circular(3)),
          ),
        ),
        const SizedBox(height: 4),
        Icon(icon, color: color),
      ],
    );
  }
}
