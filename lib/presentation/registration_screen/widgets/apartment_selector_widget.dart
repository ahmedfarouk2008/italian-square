import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ApartmentSelectorWidget extends StatelessWidget {
  final String selectedApartment;
  final Function(String) onApartmentSelected;

  const ApartmentSelectorWidget({
    super.key,
    required this.selectedApartment,
    required this.onApartmentSelected,
  });

  static final List<String> _apartments = [
    'A-101',
    'A-102',
    'A-103',
    'A-104',
    'A-105',
    'A-201',
    'A-202',
    'A-203',
    'A-204',
    'A-205',
    'A-301',
    'A-302',
    'A-303',
    'A-304',
    'A-305',
    'B-101',
    'B-102',
    'B-103',
    'B-104',
    'B-105',
    'B-201',
    'B-202',
    'B-203',
    'B-204',
    'B-205',
    'B-301',
    'B-302',
    'B-303',
    'B-304',
    'B-305',
    'C-101',
    'C-102',
    'C-103',
    'C-104',
    'C-105',
    'C-201',
    'C-202',
    'C-203',
    'C-204',
    'C-205',
    'C-301',
    'C-302',
    'C-303',
    'C-304',
    'C-305',
    'D-101',
    'D-102',
    'D-103',
    'D-104',
    'D-105',
    'D-201',
    'D-202',
    'D-203',
    'D-204',
    'D-205',
    'D-301',
    'D-302',
    'D-303',
    'D-304',
    'D-305',
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showApartmentPicker(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.5.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'home',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                selectedApartment.isEmpty
                    ? 'Select your apartment'
                    : selectedApartment,
                style: selectedApartment.isEmpty
                    ? AppTheme.lightTheme.inputDecorationTheme.hintStyle
                    : AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selectedApartment.isNotEmpty)
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 20,
                  ),
                SizedBox(width: 2.w),
                CustomIconWidget(
                  iconName: 'keyboard_arrow_down',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showApartmentPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _ApartmentPickerModal(
        apartments: _apartments,
        selectedApartment: selectedApartment,
        onApartmentSelected: (apartment) {
          onApartmentSelected(apartment);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _ApartmentPickerModal extends StatefulWidget {
  final List<String> apartments;
  final String selectedApartment;
  final Function(String) onApartmentSelected;

  const _ApartmentPickerModal({
    required this.apartments,
    required this.selectedApartment,
    required this.onApartmentSelected,
  });

  @override
  State<_ApartmentPickerModal> createState() => _ApartmentPickerModalState();
}

class _ApartmentPickerModalState extends State<_ApartmentPickerModal> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredApartments = [];

  @override
  void initState() {
    super.initState();
    _filteredApartments = widget.apartments;
    _searchController.addListener(_filterApartments);
  }

  void _filterApartments() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredApartments = widget.apartments
          .where((apartment) => apartment.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
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
            'Select Apartment',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 2.h),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search apartment number...',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        _searchController.clear();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'clear',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: _filteredApartments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'search_off',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 48,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'No apartments found',
                          style: AppTheme.lightTheme.textTheme.bodyLarge,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Try adjusting your search',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredApartments.length,
                    itemBuilder: (context, index) {
                      final apartment = _filteredApartments[index];
                      final isSelected = apartment == widget.selectedApartment;

                      return ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: 'home',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          apartment,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        trailing: isSelected
                            ? CustomIconWidget(
                                iconName: 'check_circle',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 24,
                              )
                            : null,
                        onTap: () => widget.onApartmentSelected(apartment),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
