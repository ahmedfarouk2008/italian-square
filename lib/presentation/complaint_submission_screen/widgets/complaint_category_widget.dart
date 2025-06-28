import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ComplaintCategoryWidget extends StatelessWidget {
  final Map<String, List<String>> categories;
  final String? selectedCategory;
  final String? selectedSubcategory;
  final Function(String?) onCategoryChanged;
  final Function(String?) onSubcategoryChanged;

  const ComplaintCategoryWidget({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.selectedSubcategory,
    required this.onCategoryChanged,
    required this.onSubcategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Complaint Category *',
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
              value: selectedCategory,
              hint: Text(
                'Select complaint category',
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
              items: categories.keys.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: _getCategoryIcon(category),
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        category,
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onCategoryChanged,
            ),
          ),
        ),

        // Subcategory dropdown (shown only when category is selected)
        if (selectedCategory != null) ...[
          SizedBox(height: 2.h),
          Text(
            'Subcategory',
            style: AppTheme.lightTheme.textTheme.titleSmall,
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
                value: selectedSubcategory,
                hint: Text(
                  'Select subcategory (optional)',
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
                items: categories[selectedCategory]?.map((String subcategory) {
                  return DropdownMenuItem<String>(
                    value: subcategory,
                    child: Text(
                      subcategory,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  );
                }).toList(),
                onChanged: onSubcategoryChanged,
              ),
            ),
          ),
        ],

        // Category description
        if (selectedCategory != null) ...[
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    _getCategoryDescription(selectedCategory!),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _getCategoryIcon(String category) {
    switch (category) {
      case 'Maintenance':
        return 'build';
      case 'Noise':
        return 'volume_up';
      case 'Security':
        return 'security';
      case 'Cleanliness':
        return 'cleaning_services';
      case 'Other Residents':
        return 'people';
      default:
        return 'report_problem';
    }
  }

  String _getCategoryDescription(String category) {
    switch (category) {
      case 'Maintenance':
        return 'Issues related to building maintenance, repairs, and facility upkeep.';
      case 'Noise':
        return 'Noise disturbances affecting your living environment.';
      case 'Security':
        return 'Security concerns, access issues, and safety-related problems.';
      case 'Cleanliness':
        return 'Cleanliness and hygiene issues in common areas and facilities.';
      case 'Other Residents':
        return 'Issues involving other residents\' behavior or violations.';
      default:
        return 'Please provide details about your complaint.';
    }
  }
}
