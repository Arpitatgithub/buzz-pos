import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../services/user_service.dart';

final authStateProvider =
StreamProvider<AuthState>(
  (ref) {

    return Supabase
        .instance
        .client
        .auth
        .onAuthStateChange;
  },
);

final roleProvider =
FutureProvider<String>(
  (ref) async {

    // WATCH AUTH CHANGES
    ref.watch(authStateProvider);

    final user =
        Supabase.instance.client
            .auth.currentUser;

    if (user == null) {

      return 'cashier';
    }

    return UserService()
        .getUserRole(
      user.email ?? '',
    );
  },
);