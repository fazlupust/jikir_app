class DhikrEntity {
  final String categoryId; // e.g., 'subhanallah'
  final String categoryName; // e.g., 'SubhanAllah' or 'سبحان الله'
  final String userId;
  final String date;
  final int count;
  final DateTime lastUpdated;

  DhikrEntity({
    required this.categoryId,
    required this.categoryName,
    required this.userId,
    required this.date,
    required this.count,
    required this.lastUpdated,
  });
}
