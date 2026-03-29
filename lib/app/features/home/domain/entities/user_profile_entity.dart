class UserProfileEntity {
  final String name;
  final String phone;
  final String description;
  final String role;
  final String location;
  final int dailyGoal;
  final String avatar;

  UserProfileEntity({
    required this.name,
    this.phone = '',
    this.description = '',
    this.role = 'user',
    required this.location,
    required this.dailyGoal,
    required this.avatar,
  });

  factory UserProfileEntity.empty() {
    return UserProfileEntity(
      name: 'Guest User',
      phone: '',
      description: '',
      role: 'user',
      location: '📍 Add your location',
      dailyGoal: 100,
      avatar: '🤲',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'description': description,
      'role': role,
      'location': location,
      'dailyGoal': dailyGoal,
      'avatar': avatar,
    };
  }

  factory UserProfileEntity.fromMap(Map<dynamic, dynamic> map) {
    return UserProfileEntity(
      name: map['name'] ?? 'Guest User',
      phone: map['phone'] ?? '',
      description: map['description'] ?? '',
      role: map['role'] ?? 'user',
      location: map['location'] ?? '📍 Add your location',
      dailyGoal: map['dailyGoal'] ?? 100,
      avatar: map['avatar'] ?? '🤲',
    );
  }
}
