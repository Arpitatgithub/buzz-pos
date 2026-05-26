import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import '../features/dashboard/dashboard_screen.dart';

class BuzzApp extends StatelessWidget {
  const BuzzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buzz POS',
      theme: ThemeData(

  useMaterial3: true,

  textTheme:
      GoogleFonts.nunitoTextTheme(),

  scaffoldBackgroundColor:
      const Color(0xFFF5F7FB),

  colorScheme:
      ColorScheme.fromSeed(
    seedColor: Colors.blue,
  ),
),
      home: const DashboardScreen(),
    );
  }
}