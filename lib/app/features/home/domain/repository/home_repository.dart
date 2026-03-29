import '../entities/dhikr_entity.dart';
import '../entities/user_profile_entity.dart';
import '../entities/app_settings_entity.dart';

abstract class HomeRepository {
  Future<void> saveDhikr(DhikrEntity dhikr);
  Future<int> getDhikrCount(String categoryId, String date);
  Future<Map<String, int>> getAllTimeStats(); 
  Future<Map<String, int>> getStatsForDate(String date); 
  Future<List<String>> getActiveDates(); 

  Future<void> saveProfile(UserProfileEntity profile);
  Future<UserProfileEntity> getProfile();

  Future<void> saveSettings(AppSettingsEntity settings);
  Future<AppSettingsEntity> getSettings();

  Future<void> saveTargets(Map<String, int> targets);
  Future<Map<String, int>> getTargets();

  Future<void> clearAllData();
  Future<void> clearLocalData();
  String getCurrentUserId();
  Future<void> syncHistoryFromFirebase();
}
