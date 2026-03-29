class UserEntity {
  final String uid;
  final String email;
  final String fullName;
  final String phone;
  final String authProvider;
  final String role;
  final String description;

  UserEntity({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.authProvider,
    this.role = 'user',
    this.description = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'authProvider': authProvider,
      'role': role,
      'description': description,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}
