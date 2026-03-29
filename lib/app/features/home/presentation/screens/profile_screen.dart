import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_theme.dart';
import '../controller/home_controller.dart';

class ProfileScreen extends GetView<HomeController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final appColors = context.appColors;
      final profile = controller.profile.value;
      
      final totalRecords = controller.allTimeStats.values.fold(0, (sum, val) => sum + val);

      return Container(
        color: appColors.bg,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          children: [
            // AVATAR
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  GestureDetector(
                    onLongPress: () async {
                      if (profile.role != 'admin') {
                        final uid = FirebaseAuth.instance.currentUser?.uid;
                        if (uid != null) {
                          await FirebaseFirestore.instance.collection('users').doc(uid).set({'role': 'admin'}, SetOptions(merge: true));
                          Get.snackbar("Developer Mode", "You've been granted Admin privileges! (Refresh app to see change)", snackPosition: SnackPosition.BOTTOM);
                        }
                      }
                    },
                    child: Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [appColors.card2, appColors.card]),
                        border: Border.all(color: appColors.goldD, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Text(profile.avatar, style: const TextStyle(fontSize: 35)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(profile.name, style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 20, color: appColors.txt)),
                  if (profile.role == 'admin') ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: appColors.gold, borderRadius: BorderRadius.circular(10)),
                      child: Text("ADMIN", style: TextStyle(color: appColors.bg, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    ),
                  ],
                  if (profile.phone.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(profile.phone, style: TextStyle(fontSize: 12, letterSpacing: 1, color: appColors.txt.withOpacity(0.8))),
                  ],
                  const SizedBox(height: 4),
                  Text(profile.location, style: TextStyle(fontSize: 11, letterSpacing: 1, color: appColors.txt2)),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // BADGES
            Row(
              children: [
                Expanded(child: _Badge(value: '$totalRecords', label: 'totalDhikr'.tr)),
                const SizedBox(width: 8),
                Expanded(child: _Badge(value: '${controller.activeDates.length}', label: 'daysActive'.tr)),
                const SizedBox(width: 8),
                Expanded(child: _Badge(value: '0', label: 'currentStreak'.tr)), // Simplified streak implementation for now
              ],
            ),
            const SizedBox(height: 24),

            // FORM
            Text("profileInfo".tr.toUpperCase(),
                style: TextStyle(fontSize: 10, letterSpacing: 3, color: appColors.txt3)),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: appColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: appColors.bdr),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InputRow(label: 'name'.tr, placeholder: profile.name, 
                    onChanged: (v) => controller.saveProfile(v, profile.phone, profile.description, profile.location, profile.dailyGoal)),
                  const SizedBox(height: 12),
                  _InputRow(label: 'phone'.tr, placeholder: profile.phone.isEmpty ? 'Add Phone Number' : profile.phone, isNumber: true,
                    onChanged: (v) => controller.saveProfile(profile.name, v, profile.description, profile.location, profile.dailyGoal)),
                  const SizedBox(height: 12),
                  _InputRow(label: 'Description / Bio', placeholder: profile.description.isEmpty ? 'Tell us about yourself' : profile.description, 
                    onChanged: (v) => controller.saveProfile(profile.name, profile.phone, v, profile.location, profile.dailyGoal)),
                  const SizedBox(height: 12),
                  _InputRow(label: 'location'.tr, placeholder: profile.location, 
                    onChanged: (v) => controller.saveProfile(profile.name, profile.phone, profile.description, v, profile.dailyGoal)),
                  const SizedBox(height: 12),
                  _InputRow(label: 'dailyGoal'.tr, placeholder: '${profile.dailyGoal}', isNumber: true, 
                    onChanged: (v) => controller.saveProfile(profile.name, profile.phone, profile.description, profile.location, int.tryParse(v) ?? 100)),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}

class _Badge extends StatelessWidget {
  final String value;
  final String label;

  const _Badge({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    var colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.txt2),
      ),
      child: Column(
        children: [
          Text(value, style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 22, color: colors.white)),
          const SizedBox(height: 4),
          Text(label.toUpperCase(), style: TextStyle(fontSize: 9, letterSpacing: 1, color: colors.white)),
        ],
      ),
    );
  }
}

class _InputRow extends StatelessWidget {
  final String label;
  final String placeholder;
  final bool isNumber;
  final Function(String) onChanged;

  const _InputRow({required this.label, required this.placeholder, required this.onChanged, this.isNumber = false});

  @override
  Widget build(BuildContext context) {
    var colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: TextStyle(fontSize: 10, letterSpacing: 2, color: colors.txt3)),
        const SizedBox(height: 6),
        TextField(
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: TextStyle(color: colors.txt, fontSize: 14),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: colors.txt2),
            filled: true,
            fillColor: colors.bg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colors.bdr2)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colors.bdr2)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colors.goldD)),
          ),
          onSubmitted: onChanged,
        )
      ],
    );
  }
}
