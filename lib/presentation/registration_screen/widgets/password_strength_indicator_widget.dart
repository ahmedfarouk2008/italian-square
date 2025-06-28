import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PasswordStrengthIndicatorWidget extends StatelessWidget {
  final double strength;
  final String strengthText;

  const PasswordStrengthIndicatorWidget({
    super.key,
    required this.strength,
    required this.strengthText,
  });

  @override
  Widget build(BuildContext context) {
    if (strength == 0.0) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: strength,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _getStrengthColor(),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              strengthText,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: _getStrengthColor(),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        _buildPasswordRequirements(),
      ],
    );
  }

  Color _getStrengthColor() {
    if (strength < 0.3) {
      return AppTheme.lightTheme.colorScheme.error;
    } else if (strength < 0.6) {
      return Colors.orange;
    } else if (strength < 0.8) {
      return Colors.amber;
    } else {
      return Colors.green;
    }
  }

  Widget _buildPasswordRequirements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password must contain:',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 0.5.h),
        _buildRequirement('At least 8 characters', strength >= 0.2),
        _buildRequirement('One lowercase letter', strength >= 0.4),
        _buildRequirement('One uppercase letter', strength >= 0.6),
        _buildRequirement('One number', strength >= 0.8),
        _buildRequirement('One special character', strength >= 1.0),
      ],
    );
  }

  Widget _buildRequirement(String text, bool isMet) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.2.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: isMet ? 'check_circle' : 'radio_button_unchecked',
            color: isMet
                ? Colors.green
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 14,
          ),
          SizedBox(width: 2.w),
          Text(
            text,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: isMet
                  ? Colors.green
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
