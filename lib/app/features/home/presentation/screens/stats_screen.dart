import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/dhikr_constants.dart';
import '../controller/home_controller.dart';

class StatsScreen extends GetView<HomeController> {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final appColors = context.appColors;
      final stats = controller.allTimeStats;

      int grandTotal = 0;
      stats.forEach((_, val) => grandTotal += val);

      return Container(
        color: appColors.bg,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          children: [
            Text("allTime".tr.toUpperCase(),
                style: TextStyle(fontSize: 10, letterSpacing: 3, color: appColors.txt3)),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [appColors.card, appColors.card2], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: appColors.goldD),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("allTimeGrand".tr.toUpperCase(), style: TextStyle(fontSize: 11, letterSpacing: 2, color: appColors.txt2)),
                  Text('$grandTotal', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 30, color: appColors.gold, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Text("catBreakdown".tr.toUpperCase(),
                style: TextStyle(fontSize: 10, letterSpacing: 3, color: appColors.txt3)),
            const SizedBox(height: 8),

            ...DhikrConstants.dhikrs.map((item) {
              int count = stats[item.id] ?? 0;
              if (count == 0) return const SizedBox();
              
              double pct = grandTotal > 0 ? count / grandTotal : 0;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: appColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: appColors.bdr),
                ),
                child: Row(
                  children: [
                    Container(width: 9, height: 9, decoration: BoxDecoration(color: item.color, shape: BoxShape.circle)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.ar, style: context.arabicText.copyWith(fontSize: 18)),
                          const SizedBox(height: 2),
                          Text(item.en.toUpperCase(), style: TextStyle(fontSize: 9, letterSpacing: 2, color: appColors.txt3)),
                          const SizedBox(height: 8),
                          Container(
                            height: 3, width: double.infinity,
                            decoration: BoxDecoration(color: appColors.bdr, borderRadius: BorderRadius.circular(2)),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: pct,
                              child: Container(color: item.color),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('$count', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 22, fontWeight: FontWeight.bold, color: appColors.txt)),
                        Text('${(pct * 100).toStringAsFixed(1)}%', style: TextStyle(fontSize: 9, color: appColors.txt3)),
                      ],
                    )
                  ],
                ),
              );
            }),
          ],
        ),
      );
    });
  }
}
