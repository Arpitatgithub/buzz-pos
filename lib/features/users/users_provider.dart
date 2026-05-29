import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user_model.dart';
import '../../services/users_service.dart';

final usersProvider =
    FutureProvider<List<UserModel>>(

  (ref) async {

    return UsersService()
        .fetchUsers();
  },
);

final usersRefreshProvider =
    StateProvider<int>(
  (ref) => 0,
);