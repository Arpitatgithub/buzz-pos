class UserProfile {
  final String id;
  final String email;
  final String? fullName;
  final String role;
  final bool isActive;
  final DateTime? createdAt;

  const UserProfile({
    required this.id,
    required this.email,
    this.fullName,
    required this.role,
    required this.isActive,
    this.createdAt,
  });

  factory UserProfile.fromMap(
    Map<String, dynamic> map,
  ) {
    return UserProfile(
      id: map['id'] as String,
      email: map['email'] as String,
      fullName: map['full_name'] as String?,
      role: map['role'] as String,
      isActive:
          map['is_active'] as bool? ?? true,
      createdAt:
          map['created_at'] != null
              ? DateTime.parse(
                  map['created_at'].toString(),
                )
              : null,
    );
  }
}