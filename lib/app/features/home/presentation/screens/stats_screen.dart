import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/dhikr_constants.dart';
import '../controller/home_controller.dart';

class StatsScreen extends GetView<HomeController> {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: appColors.card,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: appColors.bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: appColors.bdr),
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: appColors.card2,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: appColors.gold),
                ),
                labelColor: appColors.gold,
                unselectedLabelColor: appColors.white,
                labelStyle: const TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.5,
                ),
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(text: "allTime".tr.toUpperCase()),
                  Tab(text: "today".tr.toUpperCase()),
                  Tab(text: "thisWeek".tr.toUpperCase()),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildStatsList(
                  context,
                  controller.allTimeStats,
                  "allTimeGrand".tr,
                ),
                _buildStatsList(
                  context,
                  controller.todayStats,
                  "todayGrand".tr,
                ),
                _buildStatsList(context, controller.weekStats, "weekGrand".tr),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsList(
    BuildContext context,
    Map<String, int> statsMap,
    String grandTitle,
  ) {
    return Obx(() {
      final appColors = context.appColors;
      int grandTotal = 0;
      statsMap.forEach((_, val) => grandTotal += val);

      if (grandTotal == 0) {
        return Center(
          child: Text(
            "No records found",
            style: TextStyle(color: appColors.txt3, letterSpacing: 2),
          ),
        );
      }

      final sortedDhikrs = List.of(DhikrConstants.dhikrs)
        ..sort((a, b) => (statsMap[b.id] ?? 0).compareTo(statsMap[a.id] ?? 0));

      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [appColors.card, appColors.card2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: appColors.goldD),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  grandTitle.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 2,
                    color: appColors.txt2,
                  ),
                ),
                Text(
                  '$grandTotal',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 30,
                    color: appColors.gold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "catBreakdown".tr.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 3,
              color: appColors.txt3,
            ),
          ),
          const SizedBox(height: 8),

          ...sortedDhikrs.map((item) {
            int count = statsMap[item.id] ?? 0;
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
                  Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: item.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.ar,
                          style: context.arabicText.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.meaning.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            color: appColors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 3,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: appColors.bdr,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: pct,
                            child: Container(color: item.color),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$count',
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: appColors.txt,
                            ),
                      ),
                      Text(
                        '${(pct * 100).toStringAsFixed(1)}%',
                        style: TextStyle(fontSize: 9, color: appColors.txt3),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      );
    });
  }
}
