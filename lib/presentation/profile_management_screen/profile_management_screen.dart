import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/account_management_widget.dart';
import './widgets/app_settings_widget.dart';
import './widgets/notification_preferences_widget.dart';
import './widgets/profile_form_widget.dart';
import './widgets/profile_header_widget.dart';

class ProfileManagementScreen extends StatefulWidget {
  const ProfileManagementScreen({super.key});

  @override
  State<ProfileManagementScreen> createState() =>
      _ProfileManagementScreenState();
}

class _ProfileManagementScreenState extends State<ProfileManagementScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;

  // Mock user data
  final Map<String, dynamic> _userData = {
    "id": 1,
    "name": "Sarah Johnson",
    "email": "sarah.johnson@email.com",
    "phone": "+1 (555) 123-4567",
    "apartmentNumber": "A-204",
    "preferredContact": "email",
    "profileImage":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
    "joinDate": "2023-01-15",
    "notificationPreferences": {
      "pushNotifications": true,
      "emailUpdates": true,
      "smsAlerts": false,
      "announcements": true,
      "serviceUpdates": true,
      "emergencyAlerts": true,
    },
    "appSettings": {
      "biometricAuth": true,
      "language": "English",
      "theme": "system",
    },
    "activeSessions": [
      {
        "device": "iPhone 14",
        "lastActive": "2024-01-15 10:30 AM",
        "current": true
      },
      {
        "device": "iPad Pro",
        "lastActive": "2024-01-14 08:45 PM",
        "current": false
      },
    ]
  };

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onDataChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _hasUnsavedChanges = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: AppTheme.successLight,
        ),
      );
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to logout from your account?',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login-screen',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorLight,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        actions: [
          if (_hasUnsavedChanges)
            TextButton(
              onPressed: _isLoading ? null : _saveChanges,
              child: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      'Save',
                      style: TextStyle(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          IconButton(
            onPressed: _showLogoutDialog,
            icon: CustomIconWidget(
              iconName: 'logout',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              ProfileHeaderWidget(
                userData: _userData,
                onImageChanged: _onDataChanged,
              ),
              SizedBox(height: 2.h),
              ProfileFormWidget(
                userData: _userData,
                onDataChanged: _onDataChanged,
              ),
              SizedBox(height: 2.h),
              NotificationPreferencesWidget(
                preferences: (_userData["notificationPreferences"]
                    as Map<String, dynamic>),
                onPreferenceChanged: _onDataChanged,
              ),
              SizedBox(height: 2.h),
              AppSettingsWidget(
                settings: (_userData["appSettings"] as Map<String, dynamic>),
                onSettingChanged: _onDataChanged,
              ),
              SizedBox(height: 2.h),
              AccountManagementWidget(
                activeSessions: (_userData["activeSessions"] as List),
                onSessionRevoked: _onDataChanged,
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
