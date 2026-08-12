import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';

class LoginScreen
    extends ConsumerStatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  ConsumerState<LoginScreen>
      createState() =>
          _LoginScreenState();
}

class _LoginScreenState
    extends ConsumerState<LoginScreen> {
  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future<void> _login() async {
    if (loading) {
      return;
    }

    final email =
        emailController.text.trim();

    final password =
        passwordController.text;

    if (email.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter email and password.',
          ),
        ),
      );

      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await ref
          .read(authProvider)
          .signIn(
            email: email,
            password: password,
          );

      // RootApp listens to Supabase auth state.
      // Once sign-in succeeds, it will move
      // into BuzzApp automatically.
    } catch (e) {
      if (!mounted) {
        return;
      }

      String message =
          e.toString();

      // Remove "Exception: " from
      // our custom exceptions.
      if (message.startsWith(
        'Exception: ',
      )) {
        message =
            message.substring(11);
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(message),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 420,

          padding:
              const EdgeInsets.all(30),

          decoration:
              BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(
              20,
            ),
          ),

          child: Column(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              const Text(
                'Buzz POS',

                style: TextStyle(
                  fontSize: 32,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              TextField(
                controller:
                    emailController,

                enabled: !loading,

                keyboardType:
                    TextInputType
                        .emailAddress,

                decoration:
                    const InputDecoration(
                  labelText: 'Email',
                ),

                onSubmitted: (_) {
                  if (!loading) {
                    _login();
                  }
                },
              ),

              const SizedBox(
                height: 20,
              ),

              TextField(
                controller:
                    passwordController,

                enabled: !loading,

                obscureText: true,

                decoration:
                    const InputDecoration(
                  labelText: 'Password',
                ),

                onSubmitted: (_) {
                  if (!loading) {
                    _login();
                  }
                },
              ),

              const SizedBox(
                height: 30,
              ),

              SizedBox(
                width:
                    double.infinity,

                height: 55,

                child:
                    ElevatedButton(
                  onPressed:
                      loading
                          ? null
                          : _login,

                  child: loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Login',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}