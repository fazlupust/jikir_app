import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/dhikr_constants.dart';
import '../controller/home_controller.dart';

class HistoryScreen extends GetView<HomeController> {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final appColors = context.appColors;
      final dates = controller.filteredActiveDates;

      Map<String, List<String>> groupedDates = {};
      for (var date in dates) {
        String groupKey = "Other";
        try {
          final dt = DateTime.parse(date);
          groupKey = DateFormat('MMM yyyy').format(dt);
        } catch (_) {}
        if (!groupedDates.containsKey(groupKey)) {
          groupedDates[groupKey] = [];
        }
        groupedDates[groupKey]!.add(date);
      }

      return Container(
        color: appColors.bg,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "dailyRecords".tr.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 3,
                    color: appColors.txt3,
                  ),
                ),
                if (controller.filterYear.value != null ||
                    controller.filterMonth.value != null ||
                    controller.filterDay.value != null)
                  InkWell(
                    onTap: controller.clearFilters,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        "CLEAR FILTERS",
                        style: TextStyle(fontSize: 10, color: appColors.gold),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Filter Section
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: appColors.card,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: appColors.bdr),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int?>(
                        isExpanded: true,
                        dropdownColor: appColors.card,
                        value: controller.filterYear.value,
                        hint: Text(
                          "Year",
                          style: TextStyle(color: appColors.txt3, fontSize: 12),
                        ),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: appColors.txt3,
                          size: 20,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(
                              "All",
                              style: TextStyle(
                                color: appColors.txt2,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          ...List.generate(
                                // Calculate how many years have passed since 2026
                                // +1 ensures that 2026 is always included
                                (DateTime.now().year - 2026) + 1,
                                (i) => DateTime.now().year - i,
                              )
                              .map(
                                (y) => DropdownMenuItem(
                                  value: y,
                                  child: Text(
                                    "$y",
                                    style: TextStyle(
                                      color: appColors.txt2,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              )
                              .toList(), // Ensure .toList() is called if used inside a DropdownButton
                        ],
                        onChanged: (val) => controller.filterYear.value = val,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: appColors.card,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: appColors.bdr),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int?>(
                        isExpanded: true,
                        dropdownColor: appColors.card,
                        value: controller.filterMonth.value,
                        hint: Text(
                          "Month",
                          style: TextStyle(color: appColors.txt3, fontSize: 12),
                        ),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: appColors.txt3,
                          size: 20,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(
                              "All",
                              style: TextStyle(
                                color: appColors.txt2,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          ...List.generate(12, (i) => i + 1).map(
                            (m) => DropdownMenuItem(
                              value: m,
                              child: Text(
                                DateFormat('MMM').format(DateTime(2024, m)),
                                style: TextStyle(
                                  color: appColors.txt2,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
                        onChanged: (val) => controller.filterMonth.value = val,
                      ),
                    ),
                  ),
                ),
                // const SizedBox(width: 8),
                // Expanded(
                //   child: Container(
                //     height: 40,
                //     padding: const EdgeInsets.symmetric(horizontal: 8),
                //     decoration: BoxDecoration(
                //       color: appColors.card,
                //       borderRadius: BorderRadius.circular(8),
                //       border: Border.all(color: appColors.bdr),
                //     ),
                //     child: DropdownButtonHideUnderline(
                //       child: DropdownButton<int?>(
                //         isExpanded: true,
                //         dropdownColor: appColors.card,
                //         value: controller.filterDay.value,
                //         hint: Text("Day", style: TextStyle(color: appColors.txt3, fontSize: 12)),
                //         icon: Icon(Icons.arrow_drop_down, color: appColors.txt3, size: 20),
                //         items: [
                //           DropdownMenuItem(value: null, child: Text("All", style: TextStyle(color: appColors.txt2, fontSize: 13))),
                //           ...List.generate(31, (i) => i + 1).map((d) => DropdownMenuItem(value: d, child: Text("$d", style: TextStyle(color: appColors.txt2, fontSize: 13)))),
                //         ],
                //         onChanged: (val) => controller.filterDay.value = val,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 16),

            // All Days Grand Total
            Obx(() {
              int allTimeCount = controller.currentFilteredTotal;

              if (allTimeCount > 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
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
                          "total".tr.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 2,
                            color: appColors.txt2,
                          ),
                        ),
                        Text(
                          '$allTimeCount',
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(
                                fontSize: 26,
                                color: appColors.gold,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            if (dates.isEmpty)
              Container(
                decoration: BoxDecoration(
                  color: appColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: appColors.bdr),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Center(
                    child: Text(
                      "No records found",
                      style: TextStyle(color: appColors.txt3, letterSpacing: 2),
                    ),
                  ),
                ),
              )
            else
              ...groupedDates.entries.map((entry) {
                final groupName = entry.key;
                final groupDates = entry.value;

                int groupTotal = 0;
                for (var d in groupDates) {
                  final statsForDate = controller.historyStatsByDate[d] ?? {};
                  statsForDate.forEach((_, val) => groupTotal += val);
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              groupName.toUpperCase(),
                              style: TextStyle(
                                color: appColors.gold,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'TOTAL: $groupTotal',
                              style: TextStyle(
                                color: appColors.txt2,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: appColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: appColors.bdr),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: groupDates.length,
                          separatorBuilder: (_, __) =>
                              Divider(color: appColors.bdr, height: 1),
                          itemBuilder: (ctx, idx) {
                            final date = groupDates[idx];
                            final statsForDate =
                                controller.historyStatsByDate[date] ?? {};
                            int dayTotal = 0;
                            statsForDate.forEach((_, val) => dayTotal += val);

                            String formattedDate = date;
                            try {
                              formattedDate = DateFormat(
                                'MMM, d yyyy',
                              ).format(DateTime.parse(date));
                            } catch (e) {
                              formattedDate = date;
                            }

                            return ExpansionTile(
                              iconColor: appColors.gold,
                              collapsedIconColor: appColors.txt3,
                              shape: const Border(),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                      color: appColors.txt2,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '$dayTotal',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                          color: appColors.gold,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                    bottom: 16,
                                    top: 8,
                                  ),
                                  color: appColors.card2.withOpacity(0.3),
                                  child: Column(
                                    children: statsForDate.entries.map((e) {
                                      final dhikrItem = DhikrConstants.get(
                                        e.key,
                                      );
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8.0,
                                          top: 4.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    dhikrItem.ar,
                                                    style: context.arabicText
                                                        .copyWith(
                                                          color: appColors.txt2,
                                                          fontSize: 18,
                                                        ),
                                                  ),
                                                  Text(
                                                    dhikrItem.meaning,
                                                    style: TextStyle(
                                                      color: appColors.txt2,
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              '${e.value}',
                                              style: TextStyle(
                                                color: appColors.gold,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
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
