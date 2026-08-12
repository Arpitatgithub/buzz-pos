import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile_model.dart';
import '../services/user_profile_service.dart';

final userProfileServiceProvider =
    Provider<UserProfileService>(
  (ref) => UserProfileService(),
);

final userProfileProvider =
    FutureProvider<UserProfile?>(
  (ref) async {
    return ref
        .read(userProfileServiceProvider)
        .getCurrentProfile();
  },
);