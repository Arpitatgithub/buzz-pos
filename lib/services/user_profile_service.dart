import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_profile_model.dart';

class UserProfileService {
  final supabase =
      Supabase.instance.client;

  Future<UserProfile?> getCurrentProfile() async {
    final user =
        supabase.auth.currentUser;

    if (user == null) {
      return null;
    }

    final response = await supabase
        .from('user_profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return UserProfile.fromMap(
      response,
    );
  }

  Future<UserProfile?> getProfileById(
    String userId,
  ) async {
    final response = await supabase
        .from('user_profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return UserProfile.fromMap(
      response,
    );
  }
}