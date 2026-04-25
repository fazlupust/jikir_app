import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/dhikr_constants.dart';
import '../controller/home_controller.dart';

class CounterScreen extends GetView<HomeController> {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController chipScrollController = ScrollController();

    void scrollToSelected(String selectedId) {
      if (!chipScrollController.hasClients) return;
      final index = DhikrConstants.dhikrs.indexWhere((d) => d.id == selectedId);
      if (index < 0) return;

      const double chipWidth = 110.0;
      const double chipMargin = 8.0;
      final double itemOffset = index * (chipWidth + chipMargin);
      final double viewportWidth =
          chipScrollController.position.viewportDimension;
      final double maxScroll = chipScrollController.position.maxScrollExtent;

      // ✅ Scroll so selected chip is centered, clamped to valid range
      final double targetOffset =
          itemOffset - (viewportWidth / 2) + (chipWidth / 2);

      chipScrollController.animateTo(
        targetOffset.clamp(0.0, maxScroll),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }

    return Obx(() {
      final appColors = context.appColors;
      final curId = controller.currentCat.value;
      final curItem = DhikrConstants.get(curId);
      final tgt = controller.targets[curId] ?? curItem.target;
      final double progress = tgt > 0
          ? (controller.currentCount.value / tgt).clamp(0.0, 1.0)
          : 0.0;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToSelected(curId);
      });

      return Container(
        color: appColors.bg,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          children: [
            // 1. COLLAPSIBLE SELECT DHIKR SECTION
            Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => controller.isCollapsed.toggle(),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "SELECT DHIKR".tr.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 3,
                            color: appColors.txt3,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Obx(
                          () => Icon(
                            controller.isCollapsed.value
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up,
                            color: appColors.txt2,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => AnimatedCrossFade(
                    firstChild: const SizedBox(width: double.infinity),
                    secondChild: SizedBox(
                      height: 60,
                      child: ListView.builder(
                        controller: chipScrollController,
                        scrollDirection: Axis.horizontal,
                        // ✅ Add end padding so last item can scroll into center
                        padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width / 2,
                        ),
                        itemCount: DhikrConstants.dhikrs.length,
                        itemBuilder: (ctx, idx) {
                          final item = DhikrConstants.dhikrs[idx];
                          final isActive = item.id == curId;

                          return GestureDetector(
                            onTap: () =>
                                controller.changeDhikrCategory(item.id),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? Color.alphaBlend(
                                        item.color.withOpacity(0.12),
                                        appColors.card,
                                      )
                                    : appColors.card,
                                border: Border.all(
                                  color: isActive ? item.color : appColors.bdr,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item.ar,
                                    style: context.arabicText.copyWith(
                                      color: isActive
                                          ? item.color
                                          : appColors.txt,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    item.bn,
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: isActive
                                          ? item.color.withOpacity(0.8)
                                          : appColors.txt,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    crossFadeState: controller.isCollapsed.value
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 300),
                  ),
                ),
                Obx(
                  () => controller.isCollapsed.value
                      ? const SizedBox()
                      : const SizedBox(height: 10),
                ),
              ],
            ),

            // 2. MAIN COUNTER CARD
            Container(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 18),
              decoration: BoxDecoration(
                color: appColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: appColors.bdr),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 40,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // COLLAPSIBLE DETAILS SECTION
                  Obx(
                    () => Column(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => controller.showDetails.toggle(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller.showDetails.value
                                      ? "HIDE DETAILS"
                                      : "SHOW DETAILS",
                                  style: TextStyle(
                                    color: appColors.txt2,
                                    fontSize: 10,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  controller.showDetails.value
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: appColors.txt2,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedCrossFade(
                          firstChild: const SizedBox(width: double.infinity),
                          secondChild: Column(
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                curItem.ar,
                                textAlign: TextAlign.center,
                                style: context.arabicText.copyWith(
                                  fontSize: 35,
                                  color: curItem.color,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                curItem.meaning,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: appColors.txt,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                          crossFadeState: controller.showDetails.value
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                        ),
                      ],
                    ),
                  ),

                  // Big Number
                  Text(
                    '${controller.currentCount.value}',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 80,
                      height: 1.0,
                      color: appColors.txt,
                    ),
                  ),

                  // Target Row
                  Row(
                    children: [
                      Text(
                        "dailyTarget".tr.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 1,
                          color: appColors.txt2,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 64,
                        height: 28,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(color: appColors.gold, fontSize: 14),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            filled: true,
                            fillColor: appColors.bg,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: appColors.bdr2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: appColors.bdr2),
                            ),
                          ),
                          onSubmitted: (val) {
                            if (int.tryParse(val) != null)
                              controller.updateTarget(curId, int.parse(val));
                          },
                          controller: TextEditingController(
                            text: tgt.toString(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Progress Bar
                  Container(
                    height: 3,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: appColors.bdr,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: curItem.color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // BIG TAP BUTTON
                  GestureDetector(
                    onTap: () => controller.increment(),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: curItem.color, width: 2),
                        gradient: RadialGradient(
                          colors: [
                            curItem.color.withOpacity(0.14),
                            Colors.transparent,
                          ],
                          center: const Alignment(-0.24, -0.24),
                          radius: 0.7,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.touch_app, color: curItem.color, size: 42),
                          Text(
                            "tap".tr.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 2,
                              color: appColors.txt2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.undo, size: 14),
                        label: Text('Undo'.tr),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: appColors.txt2,
                          side: BorderSide(color: appColors.bdr2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 7,
                          ),
                        ),
                        onPressed: controller.undoStack.isNotEmpty
                            ? () => controller.undo()
                            : null,
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        icon: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.redAccent,
                        ),
                        label: Text(
                          'Reset'.tr,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: BorderSide(color: appColors.bdr2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 7,
                          ),
                        ),
                        onPressed: () => controller.resetToday(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // 3. TODAY SUMMARY
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
                    "today Total".tr.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 2,
                      color: appColors.txt,
                    ),
                  ),
                  Text(
                    '${controller.todayGrandTotal.value}',
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

            // 4. BREAKDOWN OF TODAY'S DHIKR
            if (controller.todayStats.isNotEmpty) ...[
              Builder(
                builder: (context) {
                  final sortedStats =
                      controller.todayStats.entries
                          .where((e) => e.value > 0)
                          .toList()
                        ..sort((a, b) => b.value.compareTo(a.value));

                  if (sortedStats.isEmpty) return const SizedBox();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "TODAY'S BREAKDOWN",
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 2,
                          color: appColors.txt2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...sortedStats.map((e) {
                        final dhikr = DhikrConstants.get(e.key);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: appColors.card,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: appColors.bdr),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 3,
                                height: 16,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: dhikr.color,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  dhikr.ar,
                                  style: TextStyle(
                                    color: appColors.txt,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Text(
                                '${e.value}',
                                style: TextStyle(
                                  color: appColors.txt,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ],
            const SizedBox(height: 30),
          ],
        ),
      );
    });
  }
}
