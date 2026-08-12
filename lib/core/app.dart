import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../features/dashboard/dashboard_screen.dart';
import '../providers/user_profile_provider.dart';

class BuzzApp extends StatelessWidget {
  const BuzzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buzz POS',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.nunitoTextTheme(),
        scaffoldBackgroundColor:
            const Color(0xFFF5F7FB),
        colorScheme:
            ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      home: const ProfileGate(),
    );
  }
}

class ProfileGate extends ConsumerWidget {
  const ProfileGate({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final profileAsync =
        ref.watch(userProfileProvider);

    return profileAsync.when(
      loading: () {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },

      error: (error, stackTrace) {
        return Scaffold(
          body: Center(
            child: Padding(
              padding:
                  const EdgeInsets.all(32),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 56,
                    color: Colors.red,
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  const Text(
                    'Unable to load user profile',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                    textAlign:
                        TextAlign.center,
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    error.toString(),
                    textAlign:
                        TextAlign.center,
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  ElevatedButton(
                    onPressed: () {
                      ref.invalidate(
                        userProfileProvider,
                      );
                    },
                    child: const Text(
                      'Retry',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },

      data: (profile) {
        if (profile == null) {
          return const _ProfileAccessDenied(
            message:
                'No user profile was found for this account.',
          );
        }

        if (!profile.isActive) {
          return const _ProfileAccessDenied(
            message:
                'Your Buzz POS account has been disabled.',
          );
        }

        return const DashboardScreen();
      },
    );
  }
}

class _ProfileAccessDenied
    extends StatelessWidget {
  final String message;

  const _ProfileAccessDenied({
    required this.message,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.all(32),

          child: Column(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              const Icon(
                Icons.lock_outline,
                size: 64,
                color: Colors.red,
              ),

              const SizedBox(
                height: 20,
              ),

              const Text(
                'Access Denied',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              Text(
                message,
                textAlign:
                    TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}