import '../core/supabase_client.dart';
import '../models/user_model.dart';

class UsersService {

  Future<List<UserModel>>
      fetchUsers() async {

    final response =
        await supabase
            .from('users')
            .select();

    return response
        .map<UserModel>(
          (user) =>
              UserModel.fromMap(user),
        )
        .toList();
  }

  Future<void> updateRole(
    String userId,
    String role,
  ) async {

    await supabase
        .from('users')
        .update({
          'role': role,
        })
        .eq(
          'id',
          userId,
        );
  }

  Future<void> updateStatus(
    String userId,
    bool isActive,
  ) async {

    await supabase
        .from('users')
        .update({
          'is_active': isActive,
        })
        .eq(
          'id',
          userId,
        );
  }
}

Future<bool> isUserActive(
  String email,
) async {

  final response =
      await supabase
          .from('users')
          .select('is_active')
          .eq('email', email)
          .single();

  return response['is_active']
      ?? true;
}