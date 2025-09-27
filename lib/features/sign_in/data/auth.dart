import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Sign in with email & password
  Future<AuthResponse?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response; // contains user/session info
    } on AuthException catch (e) {
      // Supabase-specific auth errors
      throw Exception(e.message);
    } catch (e) {
      // Any other error
      throw Exception('Unexpected error: $e');
    }
  }

  /// Optional: Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Check if a user is already logged in
  bool get isLoggedIn => _client.auth.currentUser != null;
}
