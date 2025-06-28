import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_service.dart';

class AuthService {
  final SupabaseService _supabaseService = SupabaseService();

  // Get current user
  User? get currentUser => _supabaseService.syncClient.auth.currentUser;

  // Get current session
  Session? get currentSession =>
      _supabaseService.syncClient.auth.currentSession;

  // Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  // Auth state stream
  Stream<AuthState> get authStateChange =>
      _supabaseService.syncClient.auth.onAuthStateChange;

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
    String? apartmentNumber,
    String role = 'resident',
  }) async {
    try {
      final client = await _supabaseService.client;
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'phone_number': phoneNumber,
          'apartment_number': apartmentNumber,
          'role': role,
        },
      );
      return response;
    } catch (error) {
      throw Exception('Sign-up failed: $error');
    }
  }

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final client = await _supabaseService.client;
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (error) {
      throw Exception('Sign-in failed: $error');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      final client = await _supabaseService.client;
      await client.auth.signOut();
    } catch (error) {
      throw Exception('Sign-out failed: $error');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      final client = await _supabaseService.client;
      await client.auth.resetPasswordForEmail(email);
    } catch (error) {
      throw Exception('Password reset failed: $error');
    }
  }

  // Update password
  Future<UserResponse> updatePassword(String newPassword) async {
    try {
      final client = await _supabaseService.client;
      final response = await client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      return response;
    } catch (error) {
      throw Exception('Password update failed: $error');
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      if (!isAuthenticated) return null;

      final client = await _supabaseService.client;
      final response = await client
          .from('user_profiles')
          .select()
          .eq('id', currentUser!.id)
          .single();

      return response;
    } catch (error) {
      throw Exception('Failed to get user profile: $error');
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? fullName,
    String? phoneNumber,
    String? apartmentNumber,
    String? buildingName,
    String? preferredContactMethod,
    String? profilePictureUrl,
  }) async {
    try {
      if (!isAuthenticated) throw Exception('User not authenticated');

      final client = await _supabaseService.client;
      final updateData = <String, dynamic>{};

      if (fullName != null) updateData['full_name'] = fullName;
      if (phoneNumber != null) updateData['phone_number'] = phoneNumber;
      if (apartmentNumber != null) {
        updateData['apartment_number'] = apartmentNumber;
      }
      if (buildingName != null) updateData['building_name'] = buildingName;
      if (preferredContactMethod != null) {
        updateData['preferred_contact_method'] = preferredContactMethod;
      }
      if (profilePictureUrl != null) {
        updateData['profile_picture_url'] = profilePictureUrl;
      }

      await client
          .from('user_profiles')
          .update(updateData)
          .eq('id', currentUser!.id);
    } catch (error) {
      throw Exception('Failed to update user profile: $error');
    }
  }
}
