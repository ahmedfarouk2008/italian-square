import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationPickerWidget extends StatelessWidget {
  final List<String> locationOptions;
  final String? selectedLocation;
  final Function(String?) onLocationChanged;

  const LocationPickerWidget({
    super.key,
    required this.locationOptions,
    required this.selectedLocation,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedLocation,
              hint: Text(
                'Select location',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              isExpanded: true,
              icon: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              items: locationOptions.map((String location) {
                return DropdownMenuItem<String>(
                  value: location,
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: _getLocationIcon(location),
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          location,
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onLocationChanged,
            ),
          ),
        ),

        if (selectedLocation != null) ...[
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'location_on',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Selected Location',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  selectedLocation!,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                SizedBox(height: 1.h),
                Text(
                  _getLocationDescription(selectedLocation!),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],

        // Quick location buttons for common areas
        SizedBox(height: 2.h),
        Text(
          'Quick Select',
          style: AppTheme.lightTheme.textTheme.labelMedium,
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _getQuickLocationOptions().map((location) {
            final isSelected = location == selectedLocation;
            return GestureDetector(
              onTap: () => onLocationChanged(location),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: _getLocationIcon(location),
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      location.split(' - ').last,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _getLocationIcon(String location) {
    if (location.contains('Apartment')) {
      return 'home';
    } else if (location.contains('Lobby')) {
      return 'meeting_room';
    } else if (location.contains('Pool')) {
      return 'pool';
    } else if (location.contains('Gym')) {
      return 'fitness_center';
    } else if (location.contains('Parking')) {
      return 'local_parking';
    } else if (location.contains('Garden')) {
      return 'local_florist';
    } else {
      return 'place';
    }
  }

  String _getLocationDescription(String location) {
    if (location.contains('Apartment')) {
      return 'Private residential unit';
    } else if (location.contains('Common Area')) {
      return 'Shared facility area';
    } else {
      return 'Building location';
    }
  }

  List<String> _getQuickLocationOptions() {
    return locationOptions
        .where((location) => location.contains('Common Area'))
        .take(4)
        .toList();
  }
}
