import '../core/supabase_client.dart';

class UserService {

  Future<String> getUserRole(
    String email,
  ) async {

    final response =
        await supabase
            .from('users')
            .select('role')
            .eq('email', email)
            .single();

    return response['role'];
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
}