import '../../services/users_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'users_provider.dart';

class UsersScreen
    extends ConsumerWidget {

  const UsersScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {

    final usersState =
        ref.watch(usersProvider);

    return usersState.when(

      loading: () =>
          const Center(
        child:
            CircularProgressIndicator(),
      ),

      error: (e, _) =>
          Center(
        child: Text(
          e.toString(),
        ),
      ),

      data: (users) {

        return Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(

              'Users',

              

              style: TextStyle(
                fontSize: 32,
                fontWeight:
                    FontWeight.bold,
              ),
            
            ),
            const SizedBox(height: 20),

Align(

  alignment:
      Alignment.centerRight,

  child: ElevatedButton.icon(
  onPressed: () {

    showDialog(
      context: context,
      builder: (_) =>
          const AddUserDialog(),
    );
  },

  icon: const Icon(
    Icons.person_add,
  ),

  label: const Text(
    'Add User',
  ),
),
),

const SizedBox(height: 20),

            const SizedBox(height: 30),

            Expanded(

  child: Container(

    padding:
        const EdgeInsets.all(20),

    decoration: BoxDecoration(

      color: Colors.white,

      borderRadius:
          BorderRadius.circular(18),
    ),

    child: SingleChildScrollView(

      child: DataTable(

        columnSpacing: 40,

        columns: const [

  DataColumn(
    label: Text('Email'),
  ),

  DataColumn(
    label: Text('Role'),
  ),

  DataColumn(
    label: Text('Status'),
  ),

  DataColumn(
    label: Text('Actions'),
  ),
],

        rows: users.map((user) {

          return DataRow(

            cells: [

              DataCell(
                Text(user.email),
              ),

              DataCell(

  Container(

    padding:
        const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 6,
    ),

    decoration: BoxDecoration(

      color:
          user.isActive
              ? Colors.green.shade100
              : Colors.red.shade100,

      borderRadius:
          BorderRadius.circular(20),
    ),

    child: Text(

      user.isActive
          ? 'Active'
          : 'Disabled',

      style: TextStyle(

        color:
            user.isActive
                ? Colors.green
                : Colors.red,

        fontWeight:
            FontWeight.bold,
      ),
    ),
  ),

  
),

DataCell(

  Container(

    padding:
        const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 6,
    ),

    decoration: BoxDecoration(

      color:
          user.isActive
              ? Colors.green.shade100
              : Colors.red.shade100,

      borderRadius:
          BorderRadius.circular(
        20,
      ),
    ),

    child: Text(

      user.isActive
          ? 'Active'
          : 'Disabled',

      style: TextStyle(

        color:
            user.isActive
                ? Colors.green
                : Colors.red,

        fontWeight:
            FontWeight.bold,
      ),
    ),
  ),
),

              DataCell(

                Row(

                  children: [

                    IconButton(

                      onPressed: () {

  showDialog(

    context: context,

    builder: (_) {

      String selectedRole =
          user.role;

      return StatefulBuilder(

        builder:
            (context, setState) {

          return AlertDialog(

            title:
                const Text(
              'Change Role',
            ),

            content:
                DropdownButton<String>(

              value:
                  selectedRole,

              items: const [

                DropdownMenuItem(
                  value: 'admin',
                  child: Text(
                    'Admin',
                  ),
                ),

                DropdownMenuItem(
                  value: 'cashier',
                  child: Text(
                    'Cashier',
                  ),
                ),
              ],

              onChanged: (value) {

                setState(() {

                  selectedRole =
                      value!;
                });
              },
            ),

            actions: [

              ElevatedButton(

                onPressed:
                    () async {

                  await UsersService()
                      .updateRole(
                    user.id,
                    selectedRole,
                  );

                  ref.invalidate(
                    usersProvider,
                  );

                  Navigator.pop(
                    context,
                  );
                },

                child:
                    const Text(
                  'Save',
                ),
              ),
            ],
          );
        },
      );
    },
  );
},

                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                    ),

                    IconButton(

                      onPressed: () async {

  await UsersService()
      .updateStatus(

    user.id,

    !user.isActive,
  );

  ref.invalidate(
    usersProvider,
  );
},

                      icon: Icon(

  user.isActive
      ? Icons.block
      : Icons.check_circle,

  color:
      user.isActive
          ? Colors.red
          : Colors.green,
),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    ),
  ),
),
          ],
        );
      },
    );
  }
}
class AddUserDialog
    extends StatefulWidget {

  const AddUserDialog({
    super.key,
  });

  @override
  State<AddUserDialog>
      createState() =>
          _AddUserDialogState();
}

class _AddUserDialogState
    extends State<AddUserDialog> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  String role = 'cashier';

  bool loading = false;

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      title: const Text(
        'Add User',
      ),

      content: SizedBox(

        width: 400,

        child: Column(

          mainAxisSize:
              MainAxisSize.min,

          children: [

            TextField(
              controller:
                  emailController,
              decoration:
                  const InputDecoration(
                labelText:
                    'Email',
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            TextField(
              controller:
                  passwordController,
              obscureText: true,
              decoration:
                  const InputDecoration(
                labelText:
                    'Password',
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            DropdownButtonFormField<String>(

              value: role,

              items: const [

                DropdownMenuItem(
                  value: 'admin',
                  child: Text(
                    'Admin',
                  ),
                ),

                DropdownMenuItem(
                  value: 'cashier',
                  child: Text(
                    'Cashier',
                  ),
                ),
              ],

              onChanged: (value) {

                setState(() {

                  role = value!;
                });
              },
            ),
          ],
        ),
      ),

      actions: [

        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          child: const Text(
            'Cancel',
          ),
        ),

        ElevatedButton(

          onPressed:
              loading
                  ? null
                  : () async {

                      setState(() {
                        loading = true;
                      });

                      try {

                        await Supabase
                            .instance
                            .client
                            .functions
                            .invoke(
                              'smart-api',
                              body: {
                                'email':
                                    emailController.text,
                                'password':
                                    passwordController.text,
                                'role':
                                    role,
                              },
                            );

                        if (context.mounted) {

                          Navigator.pop(
                            context,
                          );

                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(

                            const SnackBar(
                              content: Text(
                                'User created successfully',
                              ),
                            ),
                          );
                        }

                      } catch (e) {

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(

                          SnackBar(
                            content:
                                Text(
                              e.toString(),
                            ),
                          ),
                        );
                      }

                      setState(() {
                        loading = false;
                      });
                    },

          child:
              loading
                  ? const CircularProgressIndicator()
                  : const Text(
                      'Create User',
                    ),
        ),
      ],
    );
  }
}