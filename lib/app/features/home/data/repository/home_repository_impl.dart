import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/dhikr_entity.dart';
import '../../domain/repository/home_repository.dart';
import '../models/dhikr_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final Box _box = Hive.box('jikir_data');
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<void> saveDhikr(DhikrEntity dhikr) async {
    // Convert Entity to Model for data operations
    final model = DhikrModel(
      categoryId: dhikr.categoryId,
      categoryName: dhikr.categoryName,
      userId: dhikr.userId,
      date: dhikr.date,
      count: dhikr.count,
      lastUpdated: dhikr.lastUpdated,
    );

    // 1. LOCAL PERSISTENCE (Offline-First)
    // Key format: 2024-05-20_subhanallah
    final String localKey = "${model.date}_${model.categoryId}";
    await _box.put(localKey, model.toFirestore());

    // 2. REMOTE SYNC (Cloud Backup)
    if (model.userId.isNotEmpty) {
      try {
        await _firestore
            .collection('users')
            .doc(model.userId)
            .collection('history')
            .doc(model.date) // One document per day
            .set({
              // Uses categoryId as a dynamic key to keep counts separate
              model.categoryId: {
                'name': model.categoryName,
                'count': model.count,
                'lastUpdated': model.lastUpdated.toIso8601String(),
              },
              'last_sync': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
      } catch (e) {
        // Handle background sync errors (e.g., no internet) silently
        print("Remote sync failed: $e");
      }
    }
  }

  @override
  Future<int> getDhikrCount(String categoryId, String date) async {
    final String localKey = "${date}_$categoryId";
    final data = _box.get(localKey);

    if (data != null) {
      // If data exists, return the count from the map
      return data['count'] ?? 0;
    }
    return 0;
  }
}
