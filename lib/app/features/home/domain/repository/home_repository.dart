import '../entities/dhikr_entity.dart';

abstract class HomeRepository {
  Future<void> saveDhikr(DhikrEntity dhikr);
  Future<int> getDhikrCount(String categoryId, String date);
}
