import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../controller/home_controller.dart';

class SettingsScreen extends GetView<HomeController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final appColors = context.appColors;
      final settings = controller.settings.value;

      return Container(
        color: appColors.bg,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          children: [
            // THEME
            Text("theme".tr.toUpperCase(),
                style: TextStyle(fontSize: 10, letterSpacing: 3, color: appColors.txt3)),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _ThemeSwatch(theme: 'dark', label: 'dark'.tr, active: settings.theme == 'dark'),
                  _ThemeSwatch(theme: 'light', label: 'light'.tr, active: settings.theme == 'light'),
                  _ThemeSwatch(theme: 'ocean', label: 'ocean'.tr, active: settings.theme == 'ocean'),
                  _ThemeSwatch(theme: 'emerald', label: 'emerald'.tr, active: settings.theme == 'emerald'),
                  _ThemeSwatch(theme: 'rose', label: 'rose'.tr, active: settings.theme == 'rose'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // LANGUAGE
            Text("language".tr.toUpperCase(),
                style: TextStyle(fontSize: 10, letterSpacing: 3, color: appColors.txt3)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: [
                _LangItem(code: 'en', name: 'English', flag: '🇬🇧', active: settings.language == 'en'),
                _LangItem(code: 'ar', name: 'Arabic', flag: '🇸🇦', active: settings.language == 'ar'),
                _LangItem(code: 'bn', name: 'Bengali', flag: '🇧🇩', active: settings.language == 'bn'),
                _LangItem(code: 'ur', name: 'Urdu', flag: '🇵🇰', active: settings.language == 'ur'),
                _LangItem(code: 'tr', name: 'Turkish', flag: '🇹🇷', active: settings.language == 'tr'),
                _LangItem(code: 'id', name: 'Indonesia', flag: '🇮🇩', active: settings.language == 'id'),
              ],
            ),
            const SizedBox(height: 20),

            // GENERAL
            Text("general".tr.toUpperCase(),
                style: TextStyle(fontSize: 10, letterSpacing: 3, color: appColors.txt3)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(color: appColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: appColors.bdr)),
              child: Column(
                children: [
                  _ToggleRow(icon: '🔔', title: 'vibration'.tr, sub: 'haptic'.tr, value: settings.vibration, onChanged: controller.setVibration),
                  Divider(color: appColors.bdr, height: 1),
                  _ToggleRow(icon: '🔊', title: 'sound'.tr, sub: 'clickSound'.tr, value: settings.sound, onChanged: controller.setSound),
                  Divider(color: appColors.bdr, height: 1),
                  _ToggleRow(icon: '🌙', title: 'keepOn'.tr, sub: 'preventSleep'.tr, value: settings.keepScreenOn, onChanged: controller.setKeepScreenOn),
                  Divider(color: appColors.bdr, height: 1),
                  _ToggleRow(icon: '🎯', title: 'milestones'.tr, sub: 'milestonesSub'.tr, value: settings.milestoneAlerts, onChanged: controller.setMilestoneAlerts),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // DATA
            Text("data".tr.toUpperCase(),
                style: TextStyle(fontSize: 10, letterSpacing: 3, color: appColors.txt3)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(color: appColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: appColors.bdr)),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: appColors.card2, borderRadius: BorderRadius.circular(10)), child: const Text('📤')),
                    title: Text('export'.tr, style: TextStyle(color: appColors.txt, fontSize: 13)),
                    subtitle: Text('exportSub'.tr, style: TextStyle(color: appColors.txt3, fontSize: 10)),
                    trailing: Icon(Icons.chevron_right, color: appColors.txt3),
                    onTap: controller.exportData,
                  ),
                  Divider(color: appColors.bdr, height: 1),
                  ListTile(
                    leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: appColors.card2, borderRadius: BorderRadius.circular(10)), child: const Text('🗑')),
                    title: Text('clearData'.tr, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
                    subtitle: Text('clearSub'.tr, style: TextStyle(color: appColors.txt3, fontSize: 10)),
                    trailing: Icon(Icons.chevron_right, color: appColors.txt3),
                    onTap: () {
                      Get.defaultDialog(
                        title: "Warning",
                        middleText: "Permanently delete all records?",
                        textCancel: "Cancel",
                        textConfirm: "Clear",
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                          controller.clearAllData();
                          Get.back(); // close dialog
                        }
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}

class _ThemeSwatch extends GetView<HomeController> {
  final String theme;
  final String label;
  final bool active;

  const _ThemeSwatch({required this.theme, required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    var colors = context.appColors;
    
    // Simulate gradients for dots based on theme requested
    List<Color> grad = [Colors.black, Colors.grey];
    if(theme == 'light') grad = [Colors.white, Colors.grey.shade300];
    if(theme == 'ocean') grad = [const Color(0xFF040d18), const Color(0xFF38bdf8)];
    if(theme == 'emerald') grad = [const Color(0xFF030d08), const Color(0xFF4ade80)];
    if(theme == 'rose') grad = [const Color(0xFF0e060a), const Color(0xFFfb7185)];

    return GestureDetector(
      onTap: () => controller.setTheme(theme),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: active ? colors.gold : Colors.transparent, width: 2),
        ),
        child: Column(
          children: [
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: grad)),
            ),
            const SizedBox(height: 6),
            Text(label.toUpperCase(), style: TextStyle(fontSize: 9, letterSpacing: 1, color: colors.txt2)),
          ],
        ),
      ),
    );
  }
}

class _LangItem extends GetView<HomeController> {
  final String code;
  final String name;
  final String flag;
  final bool active;

  const _LangItem({required this.code, required this.name, required this.flag, required this.active});

  @override
  Widget build(BuildContext context) {
    var colors = context.appColors;
    return GestureDetector(
      onTap: () => controller.setLanguage(code),
      child: Container(
        width: (Get.width / 2) - 20, // rough grid width
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: active ? Color.alphaBlend(colors.gold.withOpacity(0.1), colors.card) : colors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: active ? colors.gold : colors.bdr),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(name, style: TextStyle(color: colors.txt, fontSize: 13)),
            const Spacer(),
            if (active) Icon(Icons.check, size: 14, color: colors.gold),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String icon;
  final String title;
  final String sub;
  final bool value;
  final Function(bool) onChanged;

  const _ToggleRow({required this.icon, required this.title, required this.sub, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    var colors = context.appColors;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: colors.card2, borderRadius: BorderRadius.circular(10)),
        child: Text(icon),
      ),
      title: Text(title, style: TextStyle(color: colors.txt, fontSize: 13)),
      subtitle: Text(sub, style: TextStyle(color: colors.txt3, fontSize: 10)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: colors.gold,
        activeTrackColor: colors.gold.withOpacity(0.3),
      ),
    );
  }
}
