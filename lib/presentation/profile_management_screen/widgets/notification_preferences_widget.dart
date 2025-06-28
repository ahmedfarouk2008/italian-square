import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationPreferencesWidget extends StatefulWidget {
  final Map<String, dynamic> preferences;
  final VoidCallback onPreferenceChanged;

  const NotificationPreferencesWidget({
    super.key,
    required this.preferences,
    required this.onPreferenceChanged,
  });

  @override
  State<NotificationPreferencesWidget> createState() =>
      _NotificationPreferencesWidgetState();
}

class _NotificationPreferencesWidgetState
    extends State<NotificationPreferencesWidget> {
  late Map<String, bool> _preferences;

  @override
  void initState() {
    super.initState();
    _preferences = Map<String, bool>.from(widget.preferences);
  }

  void _updatePreference(String key, bool value) {
    setState(() {
      _preferences[key] = value;
    });
    widget.onPreferenceChanged();
  }

  Widget _buildPreferenceItem({
    required String title,
    required String subtitle,
    required String iconName,
    required String preferenceKey,
    Color? iconColor,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: (iconColor ?? AppTheme.lightTheme.colorScheme.primary)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: iconColor ?? AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _preferences[preferenceKey] ?? false,
            onChanged: (value) => _updatePreference(preferenceKey, value),
            activeColor: AppTheme.lightTheme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String iconName) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24,
          ),
          SizedBox(width: 2.w),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Notification Preferences', 'notifications'),
          _buildPreferenceItem(
            title: 'Push Notifications',
            subtitle: 'Receive notifications on your device',
            iconName: 'notifications',
            preferenceKey: 'pushNotifications',
          ),
          _buildPreferenceItem(
            title: 'Email Updates',
            subtitle: 'Get updates via email',
            iconName: 'email',
            preferenceKey: 'emailUpdates',
          ),
          _buildPreferenceItem(
            title: 'SMS Alerts',
            subtitle: 'Receive text message alerts',
            iconName: 'sms',
            preferenceKey: 'smsAlerts',
          ),
          SizedBox(height: 2.h),
          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            thickness: 1,
          ),
          SizedBox(height: 2.h),
          _buildSectionHeader('Content Preferences', 'tune'),
          _buildPreferenceItem(
            title: 'Community Announcements',
            subtitle: 'Updates about community events and news',
            iconName: 'campaign',
            preferenceKey: 'announcements',
            iconColor: AppTheme.accentLight,
          ),
          _buildPreferenceItem(
            title: 'Service Updates',
            subtitle: 'Status updates for your service requests',
            iconName: 'build',
            preferenceKey: 'serviceUpdates',
            iconColor: AppTheme.successLight,
          ),
          _buildPreferenceItem(
            title: 'Emergency Alerts',
            subtitle: 'Critical safety and emergency notifications',
            iconName: 'warning',
            preferenceKey: 'emergencyAlerts',
            iconColor: AppTheme.errorLight,
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Emergency alerts cannot be disabled for your safety and security.',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
