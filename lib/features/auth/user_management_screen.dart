import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'user_management_provider.dart';

class UserManagementScreen
    extends ConsumerWidget {
  const UserManagementScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final usersAsync =
        ref.watch(
      userManagementProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Management',
        ),
      ),

      body: usersAsync.when(
        loading: () {
          return const Center(
            child:
                CircularProgressIndicator(),
          );
        },

        error: (error, stack) {
          return Center(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,

              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red,
                ),

                const SizedBox(
                  height: 12,
                ),

                Text(
                  error.toString(),
                  textAlign:
                      TextAlign.center,
                ),

                const SizedBox(
                  height: 16,
                ),

                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(
                      userManagementProvider,
                    );
                  },
                  child:
                      const Text('Retry'),
                ),
              ],
            ),
          );
        },

        data: (users) {
          if (users.isEmpty) {
            return const Center(
              child: Text(
                'No users found.',
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () {
              return ref
                  .read(
                    userManagementProvider
                        .notifier,
                  )
                  .loadUsers();
            },

            child: ListView.separated(
              padding:
                  const EdgeInsets.all(24),

              itemCount:
                  users.length,

              separatorBuilder:
                  (_, __) =>
                      const SizedBox(
                height: 12,
              ),

              itemBuilder:
                  (context, index) {
                final user =
                    users[index];

                return _UserCard(
                  user: user,
                  onStatusChanged:
                      () {
                    ref.invalidate(
                      userManagementProvider,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _UserCard
    extends ConsumerStatefulWidget {
  final Map<String, dynamic> user;

  final VoidCallback
      onStatusChanged;

  const _UserCard({
    required this.user,
    required this.onStatusChanged,
  });

  @override
  ConsumerState<_UserCard>
      createState() =>
          _UserCardState();
}

class _UserCardState
    extends ConsumerState<_UserCard> {
  bool loading = false;

  Future<void>
      _changeStatus() async {
    if (loading) {
      return;
    }

    final isActive =
        widget.user['is_active']
            as bool? ??
            false;

    final role =
        widget.user['role']
            ?.toString()
            .toLowerCase();

    final email =
        widget.user['email']
            ?.toString() ??
            '';

    final action =
        isActive
            ? 'Disable'
            : 'Enable';

    // Extra UI protection:
    // don't offer disabling an admin.
    if (role == 'admin' &&
        isActive) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Admin accounts cannot be disabled from this screen.',
          ),
        ),
      );

      return;
    }

    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            '$action User?',
          ),

          content: Text(
            isActive
                ? 'Disable $email? They will no longer be able to log in or complete sales.'
                : 'Enable $email? They will be able to log in again.',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child:
                  const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child:
                  Text(action),
            ),
          ],
        );
      },
    );

    if (confirmed != true ||
        !mounted) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await ref
          .read(
            userManagementProvider
                .notifier,
          )
          .setUserActiveStatus(
            userId:
                widget.user['id']
                    .toString(),

            isActive:
                !isActive,
          );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            isActive
                ? '$email disabled'
                : '$email enabled',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
          backgroundColor:
              Colors.red,
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
    final email =
        widget.user['email']
            ?.toString() ??
            '';

    final fullName =
        widget.user['full_name']
            ?.toString() ??
            '';

    final role =
        widget.user['role']
            ?.toString() ??
            '';

    final isActive =
        widget.user['is_active']
            as bool? ??
            false;

    final isAdmin =
        role.toLowerCase() ==
            'admin';

    return Card(
      elevation: 0,

      child: Padding(
        padding:
            const EdgeInsets.all(18),

        child: Row(
          children: [
            CircleAvatar(
              radius: 24,

              child: Icon(
                isAdmin
                    ? Icons.admin_panel_settings
                    : Icons.person,
              ),
            ),

            const SizedBox(
              width: 16,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  Text(
                    fullName.isEmpty
                        ? email
                        : fullName,

                    style:
                        const TextStyle(
                      fontSize: 17,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Text(email),

                  const SizedBox(
                    height: 8,
                  ),

                  Row(
                    children: [
                      _RoleBadge(
                        role: role,
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                      _StatusBadge(
                        isActive:
                            isActive,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (!isAdmin)
              SizedBox(
                width: 100,

                child:
                    OutlinedButton(
                  onPressed:
                      loading
                          ? null
                          : _changeStatus,

                  child: loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          isActive
                              ? 'Disable'
                              : 'Enable',
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RoleBadge
    extends StatelessWidget {
  final String role;

  const _RoleBadge({
    required this.role,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color:
            Colors.blue.shade50,

        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),

      child: Text(
        role.toUpperCase(),

        style: const TextStyle(
          fontSize: 11,
          fontWeight:
              FontWeight.bold,
        ),
      ),
    );
  }
}

class _StatusBadge
    extends StatelessWidget {
  final bool isActive;

  const _StatusBadge({
    required this.isActive,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.shade50
            : Colors.red.shade50,

        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),

      child: Text(
        isActive
            ? 'ACTIVE'
            : 'DISABLED',

        style: TextStyle(
          fontSize: 11,
          fontWeight:
              FontWeight.bold,

          color: isActive
              ? Colors.green.shade700
              : Colors.red.shade700,
        ),
      ),
    );
  }
}