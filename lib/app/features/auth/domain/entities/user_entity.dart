class UserEntity {
  final String uid;
  final String email;
  final String fullName;
  final String phone;
  final String authProvider;

  UserEntity({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.authProvider,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'authProvider': authProvider,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}
