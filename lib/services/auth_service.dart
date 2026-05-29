import 'package:supabase_flutter/supabase_flutter.dart';

import 'user_service.dart';

class AuthService {

  final supabase =
      Supabase.instance.client;

  Future<void> signIn({

    required String email,
    required String password,

  }) async {

    final response =
    await supabase.auth.signInWithPassword(
  email: email,
  password: password,
);

final isActive =
    await UserService()
        .isUserActive(email);

if (!isActive) {

  await supabase.auth.signOut();

  throw Exception(
    'Your account has been disabled. Contact administrator.',
  );
}

return;
  }

  Future<void> signOut() async {

    await supabase.auth.signOut();
  }

  User? get currentUser =>
      supabase.auth.currentUser;
}