import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ServiceFilterBottomSheet extends StatefulWidget {
  final List<String> categories;
  final List<String> selectedCategories;
  final Function(List<String>) onCategoriesChanged;

  const ServiceFilterBottomSheet({
    super.key,
    required this.categories,
    required this.selectedCategories,
    required this.onCategoriesChanged,
  });

  @override
  State<ServiceFilterBottomSheet> createState() =>
      _ServiceFilterBottomSheetState();
}

class _ServiceFilterBottomSheetState extends State<ServiceFilterBottomSheet> {
  late List<String> _tempSelectedCategories;
  double _minPrice = 0;
  double _maxPrice = 500;
  bool _availableOnly = false;

  @override
  void initState() {
    super.initState();
    _tempSelectedCategories = List.from(widget.selectedCategories);
  }

  void _toggleCategory(String category) {
    setState(() {
      if (category == "All") {
        _tempSelectedCategories.clear();
        _tempSelectedCategories.add("All");
      } else {
        _tempSelectedCategories.remove("All");
        if (_tempSelectedCategories.contains(category)) {
          _tempSelectedCategories.remove(category);
        } else {
          _tempSelectedCategories.add(category);
        }

        if (_tempSelectedCategories.isEmpty) {
          _tempSelectedCategories.add("All");
        }
      }
    });
  }

  void _applyFilters() {
    widget.onCategoriesChanged(_tempSelectedCategories);
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _tempSelectedCategories.clear();
      _tempSelectedCategories.add("All");
      _minPrice = 0;
      _maxPrice = 500;
      _availableOnly = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 12.w,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Services',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: _clearFilters,
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            height: 1,
          ),

          // Categories section
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: widget.categories.map((category) {
                    final isSelected =
                        _tempSelectedCategories.contains(category);
                    return FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) => _toggleCategory(category),
                      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                      selectedColor: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.2),
                      checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            height: 1,
          ),

          // Price range section
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price Range',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${_minPrice.round()}',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    Text(
                      '\$${_maxPrice.round()}',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                RangeSlider(
                  values: RangeValues(_minPrice, _maxPrice),
                  min: 0,
                  max: 500,
                  divisions: 10,
                  activeColor: AppTheme.lightTheme.colorScheme.primary,
                  inactiveColor: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  onChanged: (RangeValues values) {
                    setState(() {
                      _minPrice = values.start;
                      _maxPrice = values.end;
                    });
                  },
                ),
              ],
            ),
          ),

          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            height: 1,
          ),

          // Availability section
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Only',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Switch(
                  value: _availableOnly,
                  onChanged: (value) {
                    setState(() {
                      _availableOnly = value;
                    });
                  },
                  activeColor: AppTheme.lightTheme.colorScheme.primary,
                ),
              ],
            ),
          ),

          // Apply button
          Padding(
            padding: EdgeInsets.all(4.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Apply Filters',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
