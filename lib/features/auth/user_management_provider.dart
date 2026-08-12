import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/user_management_service.dart';

final userManagementProvider =
    StateNotifierProvider<
        UserManagementNotifier,
        AsyncValue<
            List<Map<String, dynamic>>>>(
  (ref) =>
      UserManagementNotifier(),
);

class UserManagementNotifier
    extends StateNotifier<
        AsyncValue<
            List<Map<String, dynamic>>>> {
  final UserManagementService service =
      UserManagementService();

  UserManagementNotifier()
      : super(const AsyncLoading()) {
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      state = const AsyncLoading();

      final users =
          await service.fetchUsers();

      state = AsyncData(users);
    } catch (e, stack) {
      state = AsyncError(
        e,
        stack,
      );
    }
  }

  Future<void> setUserActiveStatus({
    required String userId,
    required bool isActive,
  }) async {
    await service.setUserActiveStatus(
      userId: userId,
      isActive: isActive,
    );

    await loadUsers();
  }
}