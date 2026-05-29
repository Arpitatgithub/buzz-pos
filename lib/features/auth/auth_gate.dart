import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/app.dart';
import '../../services/user_service.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {

  const AuthGate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final user =
        Supabase.instance.client
            .auth.currentUser;

    if (user == null) {
      return const LoginScreen();
    }

    return FutureBuilder<bool>(

      future: UserService()
          .isUserActive(
        user.email ?? '',
      ),

      builder: (context, snapshot) {

        if (!snapshot.hasData) {

          return const Scaffold(

            body: Center(
              child:
                  CircularProgressIndicator(),
            ),
          );
        }

        final isActive =
            snapshot.data!;

        if (!isActive) {

          Future.microtask(() async {

            await Supabase
                .instance
                .client
                .auth
                .signOut();
          });

          return const LoginScreen();
        }

        return const BuzzApp();
      },
    );
  }
}