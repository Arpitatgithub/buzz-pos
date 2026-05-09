import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/app.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fzmhwlbihieimppqswos.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ6bWh3bGJpaGllaW1wcHFzd29zIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgzNTI4MDMsImV4cCI6MjA5MzkyODgwM30.XdoFC54HqiEYMcFL_kWiIwcHzYYL_p1nQv04all-wyM',
  );

  runApp(
    const ProviderScope(
      child: BuzzApp(),
    ),
  );
}