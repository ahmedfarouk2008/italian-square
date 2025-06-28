import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PriorityLevelWidget extends StatelessWidget {
  final List<String> priorityLevels;
  final String selectedPriority;
  final Function(String) onPriorityChanged;
  final Color Function(String) getPriorityColor;

  const PriorityLevelWidget({
    super.key,
    required this.priorityLevels,
    required this.selectedPriority,
    required this.onPriorityChanged,
    required this.getPriorityColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority Level',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(1.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
          ),
          child: Row(
            children: priorityLevels.map((priority) {
              final isSelected = priority == selectedPriority;
              final priorityColor = getPriorityColor(priority);

              return Expanded(
                child: GestureDetector(
                  onTap: () => onPriorityChanged(priority),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? priorityColor.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: isSelected
                          ? Border.all(color: priorityColor, width: 2)
                          : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: _getPriorityIcon(priority),
                          color: isSelected
                              ? priorityColor
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          priority,
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: isSelected
                                ? priorityColor
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: getPriorityColor(selectedPriority).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: getPriorityColor(selectedPriority).withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'schedule',
                color: getPriorityColor(selectedPriority),
                size: 16,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  _getPriorityDescription(selectedPriority),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: getPriorityColor(selectedPriority),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getPriorityIcon(String priority) {
    switch (priority) {
      case 'Low':
        return 'keyboard_arrow_down';
      case 'Medium':
        return 'remove';
      case 'High':
        return 'keyboard_arrow_up';
      case 'Urgent':
        return 'priority_high';
      default:
        return 'remove';
    }
  }

  String _getPriorityDescription(String priority) {
    switch (priority) {
      case 'Low':
        return 'Response within 3-5 business days. Non-critical issues.';
      case 'Medium':
        return 'Response within 1-2 business days. Standard priority.';
      case 'High':
        return 'Response within 24 hours. Important issues requiring attention.';
      case 'Urgent':
        return 'Immediate response required. Critical safety or security issues.';
      default:
        return 'Standard priority complaint.';
    }
  }
}
