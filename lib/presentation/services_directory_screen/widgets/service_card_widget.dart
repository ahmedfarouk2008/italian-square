import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ServiceCardWidget extends StatelessWidget {
  final Map<String, dynamic> service;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const ServiceCardWidget({
    super.key,
    required this.service,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = service["availability"] == "Available";
    final isFavorite = service["isFavorite"] ?? false;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onFavoriteToggle,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and favorite
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: (service["color"] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: service["icon"],
                      color: service["color"],
                      size: 24,
                    ),
                  ),
                  GestureDetector(
                    onTap: onFavoriteToggle,
                    child: CustomIconWidget(
                      iconName: isFavorite ? 'favorite' : 'favorite_border',
                      color: isFavorite
                          ? Colors.red
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Service name
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Text(
                service["name"],
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            SizedBox(height: 0.5.h),

            // Description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Text(
                service["description"],
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            SizedBox(height: 1.h),

            // Response time and availability
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'schedule',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 14,
                  ),
                  SizedBox(width: 1.w),
                  Expanded(
                    child: Text(
                      service["responseTime"],
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 0.5.h),

            // Availability status
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isAvailable
                          ? AppTheme.lightTheme.colorScheme.tertiary
                          : AppTheme.lightTheme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    service["availability"],
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: isAvailable
                          ? AppTheme.lightTheme.colorScheme.tertiary
                          : AppTheme.lightTheme.colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Request button
            Padding(
              padding: EdgeInsets.all(3.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isAvailable ? onTap : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAvailable
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.3),
                    foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: isAvailable ? 2 : 0,
                  ),
                  child: Text(
                    isAvailable ? 'Request' : 'Busy',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: isAvailable
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
