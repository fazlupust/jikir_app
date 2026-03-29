import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/dhikr_constants.dart';
import '../controller/home_controller.dart';

class CounterScreen extends GetView<HomeController> {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final appColors = context.appColors;
      final curId = controller.currentCat.value;
      final curItem = DhikrConstants.get(curId);
      final tgt = controller.targets[curId] ?? curItem.target;
      final double progress = tgt > 0 ? (controller.currentCount.value / tgt).clamp(0.0, 1.0) : 0.0;

      return Container(
        color: appColors.bg,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          children: [
            // 1. Carousel
            Text("selectDhikr".tr.toUpperCase(),
              style: TextStyle(fontSize: 10, letterSpacing: 3, color: appColors.txt3)),
            const SizedBox(height: 8),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: DhikrConstants.dhikrs.length,
                itemBuilder: (ctx, idx) {
                  final item = DhikrConstants.dhikrs[idx];
                  final isActive = item.id == curId;
                  
                  return GestureDetector(
                    onTap: () => controller.changeDhikrCategory(item.id),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isActive ? Color.alphaBlend(item.color.withOpacity(0.12), appColors.card) : appColors.card,
                        border: Border.all(color: isActive ? item.color : appColors.bdr, width: 1.5),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item.ar, style: context.arabicText.copyWith(color: isActive ? item.color : appColors.txt2, fontSize: 16)),
                          Text(item.bn, style: TextStyle(fontSize: 9, color: isActive ? item.color.withOpacity(0.8) : appColors.txt)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),

            // 2. Main Counter Card
            Container(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 18),
              decoration: BoxDecoration(
                color: appColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: appColors.bdr),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 40, offset: Offset(0, 12))],
              ),
              child: Column(
                children: [
                  Text(curItem.ar, textAlign: TextAlign.center, style: context.arabicText.copyWith(fontSize: 34, color: curItem.color)),
                  const SizedBox(height: 4),
                  Text(curItem.bn, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: appColors.txt, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(curItem.meaning, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: appColors.txt3, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 18),
                  
                  // Big Number
                  Text('${controller.currentCount.value}',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 80, height: 1.0, color: appColors.txt)
                  ),
                  Text("todayCount".tr.toUpperCase(), style: TextStyle(fontSize: 10, letterSpacing: 3, color: appColors.txt3)),
                  const SizedBox(height: 20),

                  // Target Row
                  Row(
                    children: [
                      Text("dailyTarget".tr.toUpperCase(), style: TextStyle(fontSize: 10, letterSpacing: 1, color: appColors.txt2)),
                      const Spacer(),
                      SizedBox(
                        width: 64, height: 28,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(color: appColors.gold, fontSize: 14),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            filled: true,
                            fillColor: appColors.bg,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: appColors.bdr2)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: appColors.bdr2)),
                          ),
                          onSubmitted: (val) {
                            if (int.tryParse(val) != null) controller.updateTarget(curId, int.parse(val));
                          },
                          controller: TextEditingController(text: tgt.toString()),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Progress Bar
                  Container(
                    height: 3,
                    width: double.infinity,
                    decoration: BoxDecoration(color: appColors.bdr, borderRadius: BorderRadius.circular(2)),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(color: curItem.color, borderRadius: BorderRadius.circular(2)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tap Button
                  GestureDetector(
                    onTap: () => controller.increment(),
                    child: Container(
                      width: 96, height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: curItem.color, width: 2),
                        gradient: RadialGradient(
                          colors: [curItem.color.withOpacity(0.14), Colors.transparent],
                          center: const Alignment(-0.24, -0.24),
                          radius: 0.7,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.touch_app, color: curItem.color, size: 32),
                          Text("tap".tr.toUpperCase(), style: TextStyle(fontSize: 10, letterSpacing: 2, color: appColors.txt2)),
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
                        label: Text('undo'.tr),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: appColors.txt2, side: BorderSide(color: appColors.bdr2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7)
                        ),
                        onPressed: controller.undoStack.isNotEmpty ? () => controller.undo() : null,
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.close, size: 14, color: Colors.redAccent),
                        label: Text('reset'.tr, style: const TextStyle(color: Colors.redAccent)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent, side: BorderSide(color: appColors.bdr2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7) // Fixed padding
                        ),
                        onPressed: () => controller.resetToday(),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 3. Today Summary
            Text("todaySummary".tr.toUpperCase(),
              style: TextStyle(fontSize: 10, letterSpacing: 3, color: appColors.txt3)),
            const SizedBox(height: 8),
            
            // Grand Total
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
                  Text("todayGrand".tr.toUpperCase(), style: TextStyle(fontSize: 11, letterSpacing: 2, color: appColors.txt2)),
                  Text('${controller.todayGrandTotal.value}', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 30, color: appColors.gold, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
