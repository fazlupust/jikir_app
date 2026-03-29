class UserProfileEntity {
  final String name;
  final String location;
  final int dailyGoal;
  final String avatar;

  UserProfileEntity({
    required this.name,
    required this.location,
    required this.dailyGoal,
    required this.avatar,
  });

  factory UserProfileEntity.empty() {
    return UserProfileEntity(
      name: 'My Profile',
      location: '📍 Add your location',
      dailyGoal: 100,
      avatar: '🤲',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'dailyGoal': dailyGoal,
      'avatar': avatar,
    };
  }

  factory UserProfileEntity.fromMap(Map<dynamic, dynamic> map) {
    return UserProfileEntity(
      name: map['name'] ?? 'My Profile',
      location: map['location'] ?? '📍 Add your location',
      dailyGoal: map['dailyGoal'] ?? 100,
      avatar: map['avatar'] ?? '🤲',
    );
  }
}
