import 'package:supabase_flutter/supabase_flutter.dart';

class UserManagementService {
  final supabase =
      Supabase.instance.client;

  // =====================================================
  // FETCH USERS
  // =====================================================

  Future<List<Map<String, dynamic>>>
      fetchUsers() async {
    final response = await supabase.rpc(
      'get_user_profiles',
    );

    return List<Map<String, dynamic>>.from(
      response,
    );
  }

  // =====================================================
  // ENABLE / DISABLE USER
  // =====================================================

  Future<void> setUserActiveStatus({
    required String userId,
    required bool isActive,
  }) async {
    await supabase.rpc(
      'set_user_active_status',
      params: {
        'p_user_id': userId,
        'p_is_active': isActive,
      },
    );
  }
}