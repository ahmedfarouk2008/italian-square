import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppSettingsWidget extends StatefulWidget {
  final Map<String, dynamic> settings;
  final VoidCallback onSettingChanged;

  const AppSettingsWidget({
    super.key,
    required this.settings,
    required this.onSettingChanged,
  });

  @override
  State<AppSettingsWidget> createState() => _AppSettingsWidgetState();
}

class _AppSettingsWidgetState extends State<AppSettingsWidget> {
  late Map<String, dynamic> _settings;

  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'ar', 'name': 'العربية', 'flag': '🇸🇦'},
    {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
    {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
  ];

  final List<Map<String, String>> _themes = [
    {'value': 'light', 'name': 'Light', 'icon': 'light_mode'},
    {'value': 'dark', 'name': 'Dark', 'icon': 'dark_mode'},
    {'value': 'system', 'name': 'System', 'icon': 'settings_brightness'},
  ];

  @override
  void initState() {
    super.initState();
    _settings = Map<String, dynamic>.from(widget.settings);
  }

  void _updateSetting(String key, dynamic value) {
    setState(() {
      _settings[key] = value;
    });
    widget.onSettingChanged();
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Select Language',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 2.h),
              ...(_languages.map((language) {
                final isSelected = _settings['language'] == language['name'];
                return ListTile(
                  leading: Text(
                    language['flag']!,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(
                    language['name']!,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  trailing: isSelected
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        )
                      : null,
                  onTap: () {
                    _updateSetting('language', language['name']);
                    Navigator.pop(context);
                  },
                );
              }).toList()),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  void _showThemePicker() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Select Theme',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 2.h),
              ...(_themes.map((theme) {
                final isSelected = _settings['theme'] == theme['value'];
                return ListTile(
                  leading: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: theme['icon']!,
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  title: Text(
                    theme['name']!,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  trailing: isSelected
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        )
                      : null,
                  onTap: () {
                    _updateSetting('theme', theme['value']);
                    Navigator.pop(context);
                  },
                );
              }).toList()),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    required String iconName,
    required VoidCallback onTap,
    Widget? trailing,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 1.h),
        padding: EdgeInsets.symmetric(vertical: 1.h),
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
            trailing ??
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
          ],
        ),
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
          Row(
            children: [
              CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'App Settings',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildSettingItem(
            title: 'Biometric Authentication',
            subtitle: 'Use fingerprint or face ID to unlock',
            iconName: 'fingerprint',
            onTap: () {
              _updateSetting(
                  'biometricAuth', !(_settings['biometricAuth'] as bool));
            },
            trailing: Switch(
              value: _settings['biometricAuth'] as bool? ?? false,
              onChanged: (value) => _updateSetting('biometricAuth', value),
              activeColor: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          _buildSettingItem(
            title: 'Language',
            subtitle: _settings['language'] as String? ?? 'English',
            iconName: 'language',
            onTap: _showLanguagePicker,
          ),
          _buildSettingItem(
            title: 'Theme',
            subtitle:
                '${(_settings['theme'] as String? ?? 'system').replaceFirst(_settings['theme'].toString()[0], _settings['theme'].toString()[0].toUpperCase())} theme',
            iconName: _themes.firstWhere(
              (theme) => theme['value'] == _settings['theme'],
              orElse: () => _themes[2],
            )['icon']!,
            onTap: _showThemePicker,
          ),
          SizedBox(height: 2.h),
          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            thickness: 1,
          ),
          SizedBox(height: 2.h),
          _buildSettingItem(
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            iconName: 'privacy_tip',
            onTap: () {
              // Navigate to privacy policy
            },
            iconColor: AppTheme.accentLight,
          ),
          _buildSettingItem(
            title: 'Terms of Service',
            subtitle: 'Read terms and conditions',
            iconName: 'description',
            onTap: () {
              // Navigate to terms of service
            },
            iconColor: AppTheme.accentLight,
          ),
          _buildSettingItem(
            title: 'Help & Support',
            subtitle: 'Get help and contact support',
            iconName: 'help',
            onTap: () {
              // Navigate to help center
            },
            iconColor: AppTheme.successLight,
          ),
        ],
      ),
    );
  }
}
