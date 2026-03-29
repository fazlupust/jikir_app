import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../controller/home_controller.dart';

class HistoryScreen extends GetView<HomeController> {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final appColors = context.appColors;
      final dates = controller.activeDates;

      return Container(
        color: appColors.bg,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          children: [
            Text("dailyRecords".tr.toUpperCase(),
                style: TextStyle(fontSize: 10, letterSpacing: 3, color: appColors.txt3)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: appColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: appColors.bdr),
              ),
              child: dates.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Center(child: Text("No records found", style: TextStyle(color: appColors.txt3, letterSpacing: 2))),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dates.length,
                      separatorBuilder: (_, __) => Divider(color: appColors.bdr, height: 1),
                      itemBuilder: (ctx, idx) {
                        final date = dates[idx];
                        final statsForDate = controller.historyStatsByDate[date] ?? {};
                        int dayTotal = 0;
                        statsForDate.forEach((_, val) => dayTotal += val);

                        return ListTile(
                          title: Text(date, style: TextStyle(color: appColors.txt2, fontSize: 13)),
                          trailing: Text('$dayTotal', 
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(color: appColors.gold, fontSize: 16, fontWeight: FontWeight.bold)
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    });
  }
}
