import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase =
      Supabase.instance.client;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await supabase.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );

    final user =
        supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'Login failed. Please try again.',
      );
    }

    final profile = await supabase
        .from('user_profiles')
        .select(
          'id, email, full_name, role, is_active',
        )
        .eq('id', user.id)
        .maybeSingle();

    if (profile == null) {
      await supabase.auth.signOut();

      throw Exception(
        'Your account profile could not be found. Contact administrator.',
      );
    }

    final isActive =
        profile['is_active'] as bool? ?? false;

    if (!isActive) {
      await supabase.auth.signOut();

      throw Exception(
        'Your account has been disabled. Contact administrator.',
      );
    }

    final role =
        profile['role']?.toString();

    if (role != 'admin' &&
        role != 'cashier') {
      await supabase.auth.signOut();

      throw Exception(
        'Your account does not have a valid Buzz POS role. Contact administrator.',
      );
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  User? get currentUser =>
      supabase.auth.currentUser;
}