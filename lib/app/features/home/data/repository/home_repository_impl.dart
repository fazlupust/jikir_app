import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/dhikr_entity.dart';
import '../../domain/entities/app_settings_entity.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repository/home_repository.dart';
import '../models/dhikr_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final Box _box = Hive.box('jikir_data');
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  String getCurrentUserId() {
    return _auth.currentUser?.uid ?? "";
  }

  @override
  Future<void> saveDhikr(DhikrEntity dhikr) async {
    final model = DhikrModel(
      categoryId: dhikr.categoryId,
      categoryName: dhikr.categoryName,
      userId: dhikr.userId,
      date: dhikr.date,
      count: dhikr.count,
      lastUpdated: dhikr.lastUpdated,
    );

    // 1. LOCAL PERSISTENCE
    final String localKey = "dhikr_${model.date}_${model.categoryId}";
    await _box.put(localKey, model.toFirestore());

    // Maintain a list of dates internally for fast querying
    List<String> dates = _box.get('active_dates', defaultValue: <dynamic>[])?.cast<String>() ?? [];
    if (!dates.contains(model.date)) {
      dates.add(model.date);
      await _box.put('active_dates', dates);
    }

    // 2. REMOTE SYNC
    if (model.userId.isNotEmpty) {
      try {
        await _firestore
            .collection('users')
            .doc(model.userId)
            .collection('history')
            .doc(model.date)
            .set({
              model.categoryId: {
                'name': model.categoryName,
                'count': model.count,
                'lastUpdated': model.lastUpdated.toIso8601String(),
              },
              'last_sync': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
      } catch (e) {
        // Handle failure silently
      }
    }
  }

  @override
  Future<int> getDhikrCount(String categoryId, String date) async {
    final String localKey = "dhikr_${date}_$categoryId";
    final data = _box.get(localKey);
    if (data != null) {
      return data['count'] ?? 0;
    }
    return 0;
  }

  @override
  Future<List<String>> getActiveDates() async {
    final rawDates = _box.get('active_dates') ?? [];
    final List<String> dates = List<String>.from(rawDates);
    dates.sort((String a, String b) => b.compareTo(a)); // Descending order
    return dates;
  }

  @override
  Future<Map<String, int>> getStatsForDate(String date) async {
    Map<String, int> stats = {};
    for (var key in _box.keys) {
      if (key.toString().startsWith("dhikr_$date")) {
        final data = _box.get(key);
        if (data != null) {
          stats[data['categoryId']] = data['count'] ?? 0;
        }
      }
    }
    return stats;
  }

  @override
  Future<Map<String, int>> getAllTimeStats() async {
    Map<String, int> stats = {};
    for (var key in _box.keys) {
      if (key.toString().startsWith("dhikr_")) {
        final data = _box.get(key);
        if (data != null) {
          String catId = data['categoryId'];
          stats[catId] = (stats[catId] ?? 0) + (data['count'] as num).toInt();
        }
      }
    }
    return stats;
  }

  @override
  Future<void> saveProfile(UserProfileEntity profile) async {
    await _box.put('user_profile', profile.toMap());
    final uid = getCurrentUserId();
    if (uid.isNotEmpty) {
      try {
        await _firestore.collection('users').doc(uid).set({
          'profile': profile.toMap()
        }, SetOptions(merge: true));
      } catch (_) {}
    }
  }

  @override
  Future<UserProfileEntity> getProfile() async {
    final data = _box.get('user_profile');
    if (data != null) {
      return UserProfileEntity.fromMap(data);
    }
    return UserProfileEntity.empty();
  }

  @override
  Future<void> saveSettings(AppSettingsEntity settings) async {
    await _box.put('app_settings', settings.toMap());
  }

  @override
  Future<AppSettingsEntity> getSettings() async {
    final data = _box.get('app_settings');
    if (data != null) {
      return AppSettingsEntity.fromMap(data);
    }
    return AppSettingsEntity.defaultSettings();
  }

  @override
  Future<void> saveTargets(Map<String, int> targets) async {
    await _box.put('dhikr_targets', targets);
  }

  @override
  Future<Map<String, int>> getTargets() async {
    final data = _box.get('dhikr_targets');
    if (data != null) {
      return Map<String, int>.from(data);
    }
    return {};
  }

  @override
  Future<void> clearAllData() async {
    final keysToDelete = _box.keys.where((k) => k.toString().startsWith("dhikr_")).toList();
    for (var key in keysToDelete) {
      await _box.delete(key);
    }
    await _box.delete('active_dates');
    // Also clear from Firebase if authenticated
    final uid = getCurrentUserId();
    if (uid.isNotEmpty) {
      try {
        final collection = _firestore.collection('users').doc(uid).collection('history');
        final snaps = await collection.get();
        for (var doc in snaps.docs) {
          await doc.reference.delete();
        }
      } catch (_) {}
    }
  }
}
