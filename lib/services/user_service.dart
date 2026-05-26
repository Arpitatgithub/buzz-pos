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
}