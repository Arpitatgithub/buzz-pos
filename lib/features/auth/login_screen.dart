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
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(

        child: Container(

          width: 420,

          padding:
              const EdgeInsets.all(
            30,
          ),

          decoration: BoxDecoration(

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

              const SizedBox(height: 30),

              TextField(

                controller:
                    emailController,

                decoration:
                    const InputDecoration(
                  labelText: 'Email',
                ),
              ),

              const SizedBox(height: 20),

              TextField(

                controller:
                    passwordController,

                obscureText: true,

                decoration:
                    const InputDecoration(
                  labelText: 'Password',
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(

                width: double.infinity,
                height: 55,

                child: ElevatedButton(

                  onPressed: loading
                      ? null
                      : () async {

                          try {

                            setState(() {
                              loading = true;
                            });

                            await ref
                                .read(
                                  authProvider,
                                )
                                .signIn(

                                  email:
                                      emailController
                                          .text,

                                  password:
                                      passwordController
                                          .text,
                                );

                          } catch (e) {

                            if (context.mounted) {

                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(

                                SnackBar(
                                  content: Text(
                                    e.toString(),
                                  ),
                                ),
                              );
                            }

                          } finally {

                            if (mounted) {

                              setState(() {
                                loading = false;
                              });
                            }
                          }
                        },

                  child: loading

                      ? const CircularProgressIndicator()

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