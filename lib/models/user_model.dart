class UserModel {

  final String id;
  final String email;
  final String role;
  final bool isActive;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.isActive,
  });

  factory UserModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      role: map['role'],
      isActive:
          map['is_active'] ?? true,
    );
  }
}