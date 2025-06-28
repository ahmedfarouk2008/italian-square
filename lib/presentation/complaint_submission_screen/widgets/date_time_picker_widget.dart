import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DateTimePickerWidget extends StatelessWidget {
  final DateTime selectedDateTime;
  final Function(DateTime) onDateTimeChanged;

  const DateTimePickerWidget({
    super.key,
    required this.selectedDateTime,
    required this.onDateTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Incident Date & Time',
          style: AppTheme.lightTheme.textTheme.titleMedium),
      SizedBox(height: 1.h),
      Text('When did this issue occur?',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
      SizedBox(height: 2.h),

      Row(children: [
        // Date picker
        Expanded(
            child: _buildDateTimeButton(context, 'Date', 'calendar_today',
                _formatDate(selectedDateTime), () => _selectDate(context))),
        SizedBox(width: 3.w),
        // Time picker
        Expanded(
            child: _buildDateTimeButton(context, 'Time', 'access_time',
                _formatTime(selectedDateTime), () => _selectTime(context))),
      ]),

      SizedBox(height: 2.h),

      // Quick date options
      Text('Quick Select', style: AppTheme.lightTheme.textTheme.labelMedium),
      SizedBox(height: 1.h),
      Wrap(spacing: 2.w, runSpacing: 1.h, children: [
        _buildQuickDateButton(
            context, 'Now', () => onDateTimeChanged(DateTime.now())),
        _buildQuickDateButton(
            context,
            'Today Morning',
            () => onDateTimeChanged(DateTime(DateTime.now().year,
                DateTime.now().month, DateTime.now().day, 8, 0))),
        _buildQuickDateButton(
            context,
            'Yesterday',
            () => onDateTimeChanged(
                DateTime.now().subtract(const Duration(days: 1)))),
        _buildQuickDateButton(
            context,
            'This Week',
            () => onDateTimeChanged(DateTime.now()
                .subtract(Duration(days: DateTime.now().weekday - 1)))),
      ]),

      SizedBox(height: 2.h),

      // Selected date/time display
      Container(
          width: double.infinity,
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CustomIconWidget(
                  iconName: 'event',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16),
              SizedBox(width: 2.w),
              Text('Selected Date & Time',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary)),
            ]),
            SizedBox(height: 1.h),
            Text(
                '${_formatDate(selectedDateTime)} at ${_formatTime(selectedDateTime)}',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500)),
            SizedBox(height: 0.5.h),
            Text(_getRelativeTime(selectedDateTime),
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.7))),
          ])),
    ]);
  }

  Widget _buildDateTimeButton(BuildContext context, String label,
      String iconName, String value, VoidCallback onTap) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: AppTheme.lightTheme.colorScheme.outline)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                CustomIconWidget(
                    iconName: iconName,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16),
                SizedBox(width: 2.w),
                Text(label,
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color:
                            AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
              ]),
              SizedBox(height: 1.h),
              Text(value,
                  style: AppTheme.lightTheme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500)),
            ])));
  }

  Widget _buildQuickDateButton(
      BuildContext context, String label, VoidCallback onTap) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: AppTheme.lightTheme.colorScheme.outline)),
            child: Text(label,
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant))));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateTime,
        firstDate: DateTime.now().subtract(const Duration(days: 365)),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return DatePickerTheme(
              data: DatePickerTheme.of(context).copyWith(), child: child!);
        });

    if (picked != null) {
      final newDateTime = DateTime(picked.year, picked.month, picked.day,
          selectedDateTime.hour, selectedDateTime.minute);
      onDateTimeChanged(newDateTime);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context)
                  .copyWith(colorScheme: AppTheme.lightTheme.colorScheme),
              child: child!);
        });

    if (picked != null) {
      final newDateTime = DateTime(
          selectedDateTime.year,
          selectedDateTime.month,
          selectedDateTime.day,
          picked.hour,
          picked.minute);
      onDateTimeChanged(newDateTime);
    }
  }

  String _formatDate(DateTime dateTime) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour == 0
        ? 12
        : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${(difference.inDays / 7).floor()} weeks ago';
    }
  }
}
