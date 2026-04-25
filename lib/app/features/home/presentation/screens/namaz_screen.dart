import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../controller/home_controller.dart';

class NamazScreen extends GetView<HomeController> {
  const NamazScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final appColors = context.appColors;
      final settings = controller.settings.value;

      return Container(
        color: appColors.bg,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            // HERO CARD FOR NAMAZ
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [appColors.goldD, appColors.card],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: appColors.gold.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))
                ],
                border: Border.all(color: appColors.gold.withOpacity(0.3), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("صَلَاة", style: context.arabicText.copyWith(fontSize: 32, color: appColors.gold, height: 1)),
                          const SizedBox(height: 4),
                          Text("নামাজের সময়সূচি", style: TextStyle(color: appColors.txt, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: appColors.bg.withOpacity(0.5), shape: BoxShape.circle),
                        child: Icon(Icons.mosque, size: 30, color: appColors.gold),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(color: appColors.bg.withOpacity(0.6), borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("নামাজের নোটিফিকেশন", style: TextStyle(color: appColors.txt, fontSize: 13, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text("প্রতি ওয়াক্তের এলার্ম চালু করুন", style: TextStyle(color: appColors.txt3, fontSize: 10)),
                          ],
                        ),
                        Switch(
                          value: settings.namazNotifications,
                          onChanged: controller.setNamazNotifications,
                          activeColor: appColors.gold,
                          activeTrackColor: appColors.gold.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // PRAYER TIMES LIST
            if (controller.prayerTimes.isNotEmpty) ...[
              Text("আজকের সময়", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1, color: appColors.txt2)),
              const SizedBox(height: 12),
              ...controller.prayerTimes.map((pt) {
                final isCurrent = pt['isCurrent'] == 'true';
                
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isCurrent ? appColors.gold.withOpacity(0.08) : appColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isCurrent ? appColors.gold : appColors.bdr),
                    boxShadow: isCurrent ? [BoxShadow(color: appColors.gold.withOpacity(0.1), blurRadius: 10)] : [],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isCurrent ? appColors.gold : appColors.card2, 
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: Icon(Icons.access_time_filled, size: 20, color: isCurrent ? appColors.bg : appColors.txt2),
                    ),
                    title: Text(pt['name']!, style: TextStyle(color: isCurrent ? appColors.gold : appColors.txt, fontSize: 16, fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('${pt['start']}  -  ${pt['end']}', style: TextStyle(color: appColors.txt3, fontSize: 12, letterSpacing: 1)),
                    ),
                    trailing: isCurrent 
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: appColors.gold, borderRadius: BorderRadius.circular(20)),
                            child: Text("চলমান", style: TextStyle(color: appColors.bg, fontSize: 11, fontWeight: FontWeight.bold)),
                          )
                        : Icon(Icons.chevron_right, color: appColors.txt3, size: 20),
                  ),
                );
              }),
            ] else ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: appColors.gold),
                      const SizedBox(height: 16),
                      Text("সময় লোড হচ্ছে...", style: TextStyle(color: appColors.txt3, fontSize: 14)),
                    ],
                  ),
                ),
              )
            ]
          ],
        ),
      );
    });
  }
}
