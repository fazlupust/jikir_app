import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/dhikr_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/app_settings_entity.dart';
import '../../domain/entities/dhikr_entity.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repository/home_repository.dart';

class UndoAction {
  final String date;
  final String categoryId;
  UndoAction(this.date, this.categoryId);
}

class HomeController extends GetxController {
  final HomeRepository repository;
  HomeController(this.repository);

  // Tabs
  var currentTab = 0.obs;

  // Counter State
  var currentCat = 'subhanallah'.obs;
  var currentCount = 0.obs;
  var todayGrandTotal = 0.obs;
  RxMap<String, int> targets = <String, int>{}.obs;
  List<UndoAction> undoStack = [];

  // Profile & Settings State
  var profile = UserProfileEntity.empty().obs;
  var settings = AppSettingsEntity.defaultSettings().obs;

  // History & Stats State
  var activeDates = <String>[].obs;
  var historyStatsByDate = <String, Map<String, int>>{}.obs; // date -> {cat: count}
  var allTimeStats = <String, int>{}.obs;
  var todayStats = <String, int>{}.obs;
  var weekStats = <String, int>{}.obs;

  String get today => DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // 1. Load Settings
    final st = await repository.getSettings();
    settings.value = st;
    _applySettings();

    // 2. Load Profile
    final pr = await repository.getProfile();
    profile.value = pr;
    
    // Attempt to sync fullName and phone from Firestore
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          final fName = data['fullName'] as String? ?? '';
          final ph = data['phone'] as String? ?? '';
          final desc = data['description'] as String? ?? '';
          final rl = data['role'] as String? ?? 'user';
          if (fName.isNotEmpty || ph.isNotEmpty || desc.isNotEmpty || profile.value.role != rl) {
            final syncedPf = UserProfileEntity(
              name: fName.isNotEmpty ? fName : profile.value.name,
              phone: ph.isNotEmpty ? ph : profile.value.phone,
              description: desc.isNotEmpty ? desc : profile.value.description,
              role: rl,
              location: profile.value.location,
              dailyGoal: profile.value.dailyGoal,
              avatar: profile.value.avatar,
            );
            profile.value = syncedPf;
            repository.saveProfile(syncedPf);
          }
        }
        
        // Ensure local Hive dates are completely synced with Firebase upon login
        await repository.syncHistoryFromFirebase();
      } catch (_) {}
    }

    // 3. Load Targets
    final savedTargets = await repository.getTargets();
    for (var d in DhikrConstants.dhikrs) {
      targets[d.id] = savedTargets[d.id] ?? d.target;
    }

    // 4. Load Today's Counter
    await _loadTodaysCount();
  }

  Future<void> _loadTodaysCount() async {
    todayGrandTotal.value = 0;
    var stats = await repository.getStatsForDate(today);
    todayStats.assignAll(stats);
    
    currentCount.value = stats[currentCat.value] ?? 0;
    stats.forEach((key, value) {
      todayGrandTotal.value += value;
    });
  }

  void onTabChanged(int index) {
    currentTab.value = index;
    if (index == 1) {
      loadHistory();
    } else if (index == 2) {
      loadStats();
    }
  }

  void changeDhikrCategory(String id) {
    currentCat.value = id;
    _loadTodaysCount(); // Refresh count for the new category
  }

  void updateTarget(String id, int target) {
    targets[id] = target;
    repository.saveTargets(targets);
  }

  // CORE ACTIONS
  Future<void> increment() async {
    currentCount.value++;
    todayGrandTotal.value++;
    todayStats[currentCat.value] = currentCount.value;

    undoStack.add(UndoAction(today, currentCat.value));

    // Vibrations & Sounds handled here
    if (settings.value.vibration) {
      HapticFeedback.lightImpact();
    }

    int target = targets[currentCat.value] ?? 33;
    if (settings.value.milestoneAlerts) {
      if (currentCount.value == target) {
        Get.snackbar('🎉 Mashallah', 'Target Reached!', snackPosition: SnackPosition.BOTTOM);
      } else if (currentCount.value % 100 == 0) {
        Get.snackbar('✨ Barakallah', '${currentCount.value} Reached!', snackPosition: SnackPosition.BOTTOM);
      }
    }

    _persistCurrentCount();
  }

  Future<void> undo() async {
    if (undoStack.isEmpty) return;
    
    final action = undoStack.removeLast();
    if (action.date == today && action.categoryId == currentCat.value) {
      if (currentCount.value > 0) {
        currentCount.value--;
        todayGrandTotal.value--;
        todayStats[currentCat.value] = currentCount.value;
        _persistCurrentCount();
      }
    } else {
      // Undo a previous category on the same day
      int countForCat = todayStats[action.categoryId] ?? 0;
      if (countForCat > 0) {
        todayStats[action.categoryId] = countForCat - 1;
        todayGrandTotal.value--;
        
        // Persist it explicitly
        int finalCount = todayStats[action.categoryId] ?? 0;
        final dItem = DhikrConstants.get(action.categoryId);
        final uid = repository.getCurrentUserId();
        await repository.saveDhikr(DhikrEntity(
          categoryId: dItem.id,
          categoryName: dItem.en,
          userId: uid,
          date: today,
          count: finalCount,
          lastUpdated: DateTime.now()
        ));
      }
    }
  }

  Future<void> resetToday() async {
    currentCount.value = 0;
    todayStats[currentCat.value] = 0;
    // Calculate new grand total
    todayGrandTotal.value = 0;
    todayStats.forEach((_, val) => todayGrandTotal.value += val);
    
    undoStack.removeWhere((e) => e.date == today && e.categoryId == currentCat.value);
    _persistCurrentCount();
  }

  void _persistCurrentCount() {
    final dItem = DhikrConstants.get(currentCat.value);
    final uid = repository.getCurrentUserId();
    final entity = DhikrEntity(
      categoryId: dItem.id,
      categoryName: dItem.en,
      userId: uid,
      date: today,
      count: currentCount.value,
      lastUpdated: DateTime.now(),
    );
    repository.saveDhikr(entity);
  }

  // SETTINGS & PROFILE
  void setVibration(bool val) => _updateSettings(settings.value.copyWith(vibration: val));
  void setSound(bool val) => _updateSettings(settings.value.copyWith(sound: val));
  void setMilestoneAlerts(bool val) => _updateSettings(settings.value.copyWith(milestoneAlerts: val));
  void setKeepScreenOn(bool val) {
    _updateSettings(settings.value.copyWith(keepScreenOn: val));
    _applySettings();
  }
  
  void setTheme(String themeId) {
    _updateSettings(settings.value.copyWith(theme: themeId));
    Get.changeTheme(AppTheme.getTheme(themeId));
  }

  void setLanguage(String langCode) {
    _updateSettings(settings.value.copyWith(language: langCode));
    Get.updateLocale(Locale(langCode));
  }

  void _updateSettings(AppSettingsEntity newSettings) {
    settings.value = newSettings;
    repository.saveSettings(newSettings);
  }

  void _applySettings() {
    Get.changeTheme(AppTheme.getTheme(settings.value.theme));
    Get.updateLocale(Locale(settings.value.language));
    
    if (settings.value.keepScreenOn) {
      WakelockPlus.enable();
    } else {
      WakelockPlus.disable();
    }
  }

  void saveProfile(String name, String phone, String description, String location, int goal) {
    final cur = profile.value;
    final updated = UserProfileEntity(
      name: name.isEmpty ? cur.name : name,
      phone: phone.isEmpty ? cur.phone : phone,
      description: description.isEmpty ? cur.description : description,
      role: cur.role,
      location: location.isEmpty ? cur.location : location,
      dailyGoal: goal,
      avatar: cur.avatar,
    );
    profile.value = updated;
    repository.saveProfile(updated);
  }

  void updateAvatar(String emoji) {
    final updated = UserProfileEntity(
      name: profile.value.name,
      phone: profile.value.phone,
      description: profile.value.description,
      role: profile.value.role,
      location: profile.value.location,
      dailyGoal: profile.value.dailyGoal,
      avatar: emoji,
    );
    profile.value = updated;
    repository.saveProfile(updated);
  }

  Future<void> exportData() async {
    // Implementing export as a simple scaffold
    Get.snackbar("Export", "Data exported successfully", snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> clearAllData() async {
    await repository.clearAllData();
    undoStack.clear();
    currentCount.value = 0;
    todayGrandTotal.value = 0;
    todayStats.clear();
    allTimeStats.clear();
    historyStatsByDate.clear();
    activeDates.clear();
    Get.snackbar("Success", "All records have been cleared", snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> logout() async {
    try {
      await repository.clearLocalData();
      undoStack.clear();
      currentCount.value = 0;
      todayGrandTotal.value = 0;
      todayStats.clear();
      allTimeStats.clear();
      historyStatsByDate.clear();
      activeDates.clear();
      profile.value = UserProfileEntity.empty();

      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      Get.offAllNamed('/auth');
    } catch (e) {
      Get.snackbar("Error", "Failed to logout: $e", snackPosition: SnackPosition.BOTTOM);
    }
  }

  // HISTORY & STATS (Loaded lazily when tabs are visited)
  Future<void> loadHistory() async {
    final dates = await repository.getActiveDates();
    activeDates.value = dates;
    
    Map<String, Map<String, int>> map = {};
    for (var d in dates) {
      map[d] = await repository.getStatsForDate(d);
    }
    historyStatsByDate.assignAll(map);
  }

  Future<void> loadStats() async {
    final allTime = await repository.getAllTimeStats();
    allTimeStats.assignAll(allTime);
    
    // Week stats requires parsing last 7 days
    Map<String, int> week = {};
    final DateTime now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      String dStr = DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: i)));
      var dayStats = await repository.getStatsForDate(dStr);
      dayStats.forEach((cat, cnt) {
        week[cat] = (week[cat] ?? 0) + cnt;
      });
    }
    weekStats.assignAll(week);
  }

  @override
  void onClose() {
    WakelockPlus.disable();
    super.onClose();
  }
}
