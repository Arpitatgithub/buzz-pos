import 'features/auth/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/login_screen.dart';
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fzmhwlbihieimppqswos.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ6bWh3bGJpaGllaW1wcHFzd29zIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgzNTI4MDMsImV4cCI6MjA5MzkyODgwM30.XdoFC54HqiEYMcFL_kWiIwcHzYYL_p1nQv04all-wyM',
  );

  runApp(
  const ProviderScope(
    child: RootApp(),
  ),
);
}
class RootApp extends StatelessWidget {

  const RootApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(

      stream: Supabase.instance.client.auth
          .onAuthStateChange,

      builder: (context, snapshot) {

        final session =
            Supabase.instance.client.auth
                .currentSession;

        return const MaterialApp(

  debugShowCheckedModeBanner:
      false,

  home: AuthGate(),
);
      },
    );
  }
}