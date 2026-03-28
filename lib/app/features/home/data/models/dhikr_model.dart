import '../../domain/entities/dhikr_entity.dart';

class DhikrModel extends DhikrEntity {
  DhikrModel({
    required super.categoryId,
    required super.categoryName,
    required super.userId,
    required super.date,
    required super.count,
    required super.lastUpdated,
  });

  // Convert Entity to Map for Firestore/Hive
  Map<String, dynamic> toFirestore() => {
    'categoryId': categoryId,
    'categoryName': categoryName,
    'userId': userId,
    'date': date,
    'count': count,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  // Create Model from Firestore/Map data
  factory DhikrModel.fromMap(Map<String, dynamic> map) {
    return DhikrModel(
      categoryId: map['categoryId'] ?? '',
      categoryName: map['categoryName'] ?? '',
      userId: map['userId'] ?? '',
      date: map['date'] ?? '',
      count: map['count'] ?? 0,
      lastUpdated: map['lastUpdated'] != null
          ? DateTime.parse(map['lastUpdated'])
          : DateTime.now(),
    );
  }
}
