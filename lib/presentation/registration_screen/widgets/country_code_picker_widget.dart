import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CountryCodePickerWidget extends StatelessWidget {
  final String selectedCountryCode;
  final Function(String) onCountryCodeSelected;

  const CountryCodePickerWidget({
    super.key,
    required this.selectedCountryCode,
    required this.onCountryCodeSelected,
  });

  static final List<Map<String, String>> _countryCodes = [
    {'name': 'United States', 'code': '+1', 'flag': '🇺🇸'},
    {'name': 'United Kingdom', 'code': '+44', 'flag': '🇬🇧'},
    {'name': 'Canada', 'code': '+1', 'flag': '🇨🇦'},
    {'name': 'Australia', 'code': '+61', 'flag': '🇦🇺'},
    {'name': 'Germany', 'code': '+49', 'flag': '🇩🇪'},
    {'name': 'France', 'code': '+33', 'flag': '🇫🇷'},
    {'name': 'Italy', 'code': '+39', 'flag': '🇮🇹'},
    {'name': 'Spain', 'code': '+34', 'flag': '🇪🇸'},
    {'name': 'Netherlands', 'code': '+31', 'flag': '🇳🇱'},
    {'name': 'India', 'code': '+91', 'flag': '🇮🇳'},
    {'name': 'China', 'code': '+86', 'flag': '🇨🇳'},
    {'name': 'Japan', 'code': '+81', 'flag': '🇯🇵'},
    {'name': 'South Korea', 'code': '+82', 'flag': '🇰🇷'},
    {'name': 'Brazil', 'code': '+55', 'flag': '🇧🇷'},
    {'name': 'Mexico', 'code': '+52', 'flag': '🇲🇽'},
  ];

  @override
  Widget build(BuildContext context) {
    final selectedCountry = _countryCodes.firstWhere(
      (country) => country['code'] == selectedCountryCode,
      orElse: () => _countryCodes.first,
    );

    return GestureDetector(
      onTap: () => _showCountryPicker(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.5.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedCountry['flag'] ?? '🇺🇸',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(width: 1.w),
            Text(
              selectedCountryCode,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(width: 1.w),
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showCountryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        height: 60.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
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
              'Select Country Code',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView.builder(
                itemCount: _countryCodes.length,
                itemBuilder: (context, index) {
                  final country = _countryCodes[index];
                  final isSelected = country['code'] == selectedCountryCode;

                  return ListTile(
                    leading: Text(
                      country['flag'] ?? '',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    title: Text(
                      country['name'] ?? '',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          country['code'] ?? '',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isSelected) ...[
                          SizedBox(width: 2.w),
                          CustomIconWidget(
                            iconName: 'check',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          ),
                        ],
                      ],
                    ),
                    onTap: () {
                      onCountryCodeSelected(country['code'] ?? '+1');
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
