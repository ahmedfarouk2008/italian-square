import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _currentUser;
  Map<String, dynamic>? _userProfile;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get currentUser => _currentUser;
  Map<String, dynamic>? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _currentUser = _authService.currentUser;
    
    // Listen to auth state changes
    _authService.authStateChange.listen((AuthState data) {
      _currentUser = data.session?.user;
      if (_currentUser != null) {
        _loadUserProfile();
      } else {
        _userProfile = null;
      }
      notifyListeners();
    });

    // Load user profile if already authenticated
    if (_currentUser != null) {
      _loadUserProfile();
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      _userProfile = await _authService.getUserProfile();
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  // Sign up
  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
    String? apartmentNumber,
    String role = 'resident',
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _authService.signUp(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
        apartmentNumber: apartmentNumber,
        role: role,
      );

      if (response.user != null) {
        _currentUser = response.user;
        await _loadUserProfile();
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign in
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _authService.signIn(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _currentUser = response.user;
        await _loadUserProfile();
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.signOut();
      _currentUser = null;
      _userProfile = null;
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? apartmentNumber,
    String? buildingName,
    String? preferredContactMethod,
    String? profilePictureUrl,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.updateUserProfile(
        fullName: fullName,
        phoneNumber: phoneNumber,
        apartmentNumber: apartmentNumber,
        buildingName: buildingName,
        preferredContactMethod: preferredContactMethod,
        profilePictureUrl: profilePictureUrl,
      );

      // Reload user profile to get updated data
      await _loadUserProfile();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}