import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:adhan/adhan.dart';
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

  // Notifications & Namaz
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var prayerTimes = <Map<String, String>>[].obs;
  var nextPrayerCountdown = ''.obs;
  Timer? _namazTimer;

  // History & Stats State
  var activeDates = <String>[].obs;
  var historyStatsByDate =
      <String, Map<String, int>>{}.obs; // date -> {cat: count}
  var allTimeStats = <String, int>{}.obs;
  var todayStats = <String, int>{}.obs;
  var weekStats = <String, int>{}.obs;

  // Filters
  var filterDay = Rxn<int>();
  var filterMonth = Rxn<int>();
  var filterYear = Rxn<int>();
  final RxBool showDetails = true.obs;
  final RxBool isCollapsed = false.obs;
  List<String> get filteredActiveDates {
    if (filterDay.value == null &&
        filterMonth.value == null &&
        filterYear.value == null) {
      return activeDates.toList();
    }
    return activeDates.where((dateStr) {
      try {
        final d = DateTime.parse(dateStr);
        bool matchDay = filterDay.value == null || d.day == filterDay.value;
        bool matchMonth =
            filterMonth.value == null || d.month == filterMonth.value;
        bool matchYear = filterYear.value == null || d.year == filterYear.value;
        return matchDay && matchMonth && matchYear;
      } catch (e) {
        return false;
      }
    }).toList();
  }

  int get currentFilteredTotal {
    int total = 0;
    for (var date in filteredActiveDates) {
      final stats = historyStatsByDate[date] ?? {};
      for (var val in stats.values) {
        total += val;
      }
    }
    return total;
  }

  void clearFilters() {
    filterDay.value = null;
    filterMonth.value = null;
    filterYear.value = null;
  }

  String get today => DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void onInit() {
    super.onInit();
    _initNotifications();
    _loadInitialData();
  }

  Future<void> _initNotifications() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _loadInitialData() async {
    // 1. Load Settings
    final st = await repository.getSettings();
    settings.value = st;
    _applySettings();
    _calculatePrayerTimes();

    // 2. Load Profile
    final pr = await repository.getProfile();
    profile.value = pr;
    print(pr);
    // Attempt to sync fullName and phone from Firestore
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();
        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          print("data");
          print(data);
          final fName = data['fullName'] as String? ?? '';
          final ph = data['phone'] as String? ?? '';
          final desc = data['description'] as String? ?? '';
          final rl = data['role'] as String? ?? 'user';
          if (fName.isNotEmpty ||
              ph.isNotEmpty ||
              desc.isNotEmpty ||
              profile.value.role != rl) {
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
    // Load total count for this category today
    var stats = await repository.getStatsForDate(today);
    todayStats.assignAll(stats);

    // Determine the current session count. If the user wants the counter
    // to reset independently, we load the total as the initial counter amount,
    // but when they reset, only currentCount will be 0.
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

    // Accumulate the daily stat instead of setting it to currentCount
    todayStats[currentCat.value] = (todayStats[currentCat.value] ?? 0) + 1;

    undoStack.add(UndoAction(today, currentCat.value));

    // Vibrations & Sounds handled here
    if (settings.value.vibration) {
      HapticFeedback.lightImpact();
    }
    if (settings.value.sound) {
      SystemSound.play(SystemSoundType.click);
    }

    int target = targets[currentCat.value] ?? 33;
    if (settings.value.milestoneAlerts) {
      if (currentCount.value == target) {
        Get.snackbar(
          '🎉 Mashallah',
          'Target Reached!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.scaffoldBackgroundColor,
        );
      } else if (currentCount.value > 0 && currentCount.value % 100 == 0) {
        Get.snackbar(
          '✨ Barakallah',
          '${currentCount.value} Reached!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.scaffoldBackgroundColor,
        );
      }
    }

    _persistDbCount(currentCat.value);
  }

  Future<void> undo() async {
    if (undoStack.isEmpty) return;

    final action = undoStack.removeLast();
    if (action.date == today && action.categoryId == currentCat.value) {
      if (currentCount.value > 0) currentCount.value--;

      int countForCat = todayStats[currentCat.value] ?? 0;
      if (countForCat > 0) {
        todayStats[currentCat.value] = countForCat - 1;
        todayGrandTotal.value--;
        _persistDbCount(currentCat.value);
      }
    } else {
      // Undo a previous category on the same day
      int countForCat = todayStats[action.categoryId] ?? 0;
      if (countForCat > 0) {
        todayStats[action.categoryId] = countForCat - 1;
        todayGrandTotal.value--;
        _persistDbCount(action.categoryId);
      }
    }
  }

  Future<void> resetToday() async {
    // Only reset the visual counter
    currentCount.value = 0;
  }

  void _persistDbCount(String categoryId) {
    int finalCount = todayStats[categoryId] ?? 0;
    final dItem = DhikrConstants.get(categoryId);
    final uid = repository.getCurrentUserId();

    final entity = DhikrEntity(
      categoryId: dItem.id,
      categoryName: dItem.en,
      userId: uid,
      date: today,
      count: finalCount,
      lastUpdated: DateTime.now(),
    );
    repository.saveDhikr(entity);
  }

  // SETTINGS & PROFILE
  void setVibration(bool val) =>
      _updateSettings(settings.value.copyWith(vibration: val));
  void setSound(bool val) =>
      _updateSettings(settings.value.copyWith(sound: val));
  void setMilestoneAlerts(bool val) =>
      _updateSettings(settings.value.copyWith(milestoneAlerts: val));
  void setKeepScreenOn(bool val) {
    _updateSettings(settings.value.copyWith(keepScreenOn: val));
    _applySettings();
  }

  void setNamazNotifications(bool val) {
    _updateSettings(settings.value.copyWith(namazNotifications: val));
    if (!val) {
      flutterLocalNotificationsPlugin.cancelAll();
    } else {
      _calculatePrayerTimes();
    }
  }

  void _calculatePrayerTimes() {
    // Default config to Dhaka for demonstration
    final coordinates = Coordinates(23.8103, 90.4125);
    final params = CalculationMethod.karachi.getParameters();
    params.madhab = Madhab.hanafi;
    final date = DateComponents.from(DateTime.now());
    final ptObj = PrayerTimes(coordinates, date, params);

    final format = DateFormat.jm();
    
    // Check if current time is within range
    String checkNow(DateTime time1, DateTime time2) {
      final now = DateTime.now();
      if (now.isAfter(time1) && now.isBefore(time2)) return 'true';
      return 'false';
    }

    prayerTimes.assignAll([
      {
        'name': 'ফজর',
        'start': format.format(ptObj.fajr),
        'end': format.format(ptObj.sunrise),
        'isCurrent': checkNow(ptObj.fajr, ptObj.sunrise)
      },
      {
        'name': 'যোহর',
        'start': format.format(ptObj.dhuhr),
        'end': format.format(ptObj.asr),
        'isCurrent': checkNow(ptObj.dhuhr, ptObj.asr)
      },
      {
        'name': 'আসর',
        'start': format.format(ptObj.asr),
        'end': format.format(ptObj.maghrib),
        'isCurrent': checkNow(ptObj.asr, ptObj.maghrib)
      },
      {
        'name': 'মাগরিব',
        'start': format.format(ptObj.maghrib),
        'end': format.format(ptObj.isha),
        'isCurrent': checkNow(ptObj.maghrib, ptObj.isha)
      },
      {
        'name': 'এশা',
        'start': format.format(ptObj.isha),
        'end': format.format(ptObj.fajr.add(const Duration(days: 1))),
        'isCurrent': checkNow(ptObj.isha, DateTime.now().add(const Duration(hours: 1))) 
      },
    ]);

    _startNamazTimer(ptObj);

    if (settings.value.namazNotifications) {
      _scheduleNotifications(ptObj);
    }
  }

  void _startNamazTimer(PrayerTimes ptObj) {
    _namazTimer?.cancel();
    _updateCountdown(ptObj);
    _namazTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateCountdown(ptObj);
    });
  }

  void _updateCountdown(PrayerTimes ptObj) {
    final now = DateTime.now();

    // 1. UPDATE ACTIVE PRAYER (NOW) DYNAMICALLY
    String checkNow(DateTime time1, DateTime time2) {
      if (now.isAfter(time1) && now.isBefore(time2)) return 'true';
      return 'false';
    }

    if (prayerTimes.isNotEmpty) {
      final updatedList = List<Map<String, String>>.from(prayerTimes.map((e) => Map<String, String>.from(e)));
      updatedList[0]['isCurrent'] = checkNow(ptObj.fajr, ptObj.sunrise);
      updatedList[1]['isCurrent'] = checkNow(ptObj.dhuhr, ptObj.asr);
      updatedList[2]['isCurrent'] = checkNow(ptObj.asr, ptObj.maghrib);
      updatedList[3]['isCurrent'] = checkNow(ptObj.maghrib, ptObj.isha);
      
      // For Isha, it spans through midnight till next day Fajr
      bool isIsha = now.isAfter(ptObj.isha) || now.isBefore(ptObj.fajr);
      updatedList[4]['isCurrent'] = isIsha ? 'true' : 'false';

      prayerTimes.assignAll(updatedList);
    }

    // 2. CALCULATE NEXT PRAYER & COUNTDOWN
    var next = ptObj.nextPrayer();
    
    DateTime? nextTime;
    String name = '';
    
    if (next == Prayer.none) {
      // Very simple fallback: just use tomorrow's Fajr
      final tomorrowParams = CalculationMethod.karachi.getParameters();
      tomorrowParams.madhab = Madhab.hanafi;
      final tomorrowDate = DateComponents.from(now.add(const Duration(days: 1)));
      final tomorrowPt = PrayerTimes(ptObj.coordinates, tomorrowDate, tomorrowParams);
      nextTime = tomorrowPt.fajr;
      name = 'ফজর';
    } else {
      nextTime = ptObj.timeForPrayer(next)!;
      switch(next) {
        case Prayer.fajr: name = 'ফজর'; break;
        case Prayer.sunrise: name = 'সূর্যোদয়'; break;
        case Prayer.dhuhr: name = 'যোহর'; break;
        case Prayer.asr: name = 'আসর'; break;
        case Prayer.maghrib: name = 'মাগরিব'; break;
        case Prayer.isha: name = 'এশা'; break;
        default: break;
      }
    }

    final diff = nextTime.difference(now);
    
    // Only show if it's within 45 minutes
    if (diff.isNegative || diff.inMinutes > 45) {
      nextPrayerCountdown.value = '';
      return;
    }
    
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    
    String timeStr = '';
    if (hours > 0) {
      timeStr = '$hours ঘণ্টা ';
    }
    if (minutes >= 0 || hours > 0) {
      timeStr += '$minutes মিনিট';
    }
    
    // Ignore Sunrise warning technically, but show if it's there
    if (name == 'সূর্যোদয়') {
      nextPrayerCountdown.value = 'সূর্যোদয় হতে বাকি: $timeStr';
    } else {
      nextPrayerCountdown.value = 'পরবর্তী $name শুরু হতে বাকি: $timeStr';
    }
  }


  Future<void> _scheduleNotifications(PrayerTimes pt) async {
    await flutterLocalNotificationsPlugin.cancelAll(); // Clear old

    void schedule(int id, String name, DateTime time) async {
      if (time.isBefore(DateTime.now())) return; 
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'নামাজের সময়',
        'এখন $name নামাজের সময় হয়েছে',
        tz.TZDateTime.from(time, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails('namaz_channel', 'Namaz Notifications', channelDescription: 'Reminders for daily Namaz', importance: Importance.max, priority: Priority.high),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }

    schedule(1, 'ফজর', pt.fajr);
    schedule(2, 'যোহর', pt.dhuhr);
    schedule(3, 'আসর', pt.asr);
    schedule(4, 'মাগরিব', pt.maghrib);
    schedule(5, 'এশা', pt.isha);
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

  void saveProfile(
    String name,
    String phone,
    String description,
    String location,
    int goal,
  ) {
    print('save pro');
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

  Future<void> updateRemoteProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'fullName': profile.value.name,
          'phone': profile.value.phone,
          'description': profile.value.description,
          'location': profile.value.location,
          'dailyGoal': profile.value.dailyGoal,
        }, SetOptions(merge: true));
        Get.snackbar(
          "Success",
          "Profile updated successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.scaffoldBackgroundColor,
        );
      } catch (e) {
        Get.snackbar(
          "Error",
          "Failed to update profile",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.scaffoldBackgroundColor,
        );
      }
    } else {
      Get.snackbar(
        "Info",
        "Profile saved locally",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.scaffoldBackgroundColor,
      );
    }
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
    try {
      final jsonStr = await repository.exportDataToJson();
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/jikir_backup.json');
      await file.writeAsString(jsonStr);

      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Jikir App Backup Data');
    } catch (e) {
      Get.snackbar(
        "Export Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.scaffoldBackgroundColor,
      );
    }
  }

  Future<void> importData() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        String filepath = result.files.single.path!;
        String jsonStr = await File(filepath).readAsString();
        await repository.importDataFromJson(jsonStr);

        // Reload UI Data
        await _loadInitialData();
        Get.snackbar(
          "Success",
          "Data imported successfully. App refreshed.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.scaffoldBackgroundColor,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Import Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.scaffoldBackgroundColor,
      );
    }
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
    Get.snackbar(
      "Success",
      "All records have been cleared",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.primaryColor,
      colorText: Get.theme.scaffoldBackgroundColor,
    );
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
      Get.snackbar(
        "Error",
        "Failed to logout: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.scaffoldBackgroundColor,
      );
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
      String dStr = DateFormat(
        'yyyy-MM-dd',
      ).format(now.subtract(Duration(days: i)));
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
    _namazTimer?.cancel();
    super.onClose();
  }
}
