import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileFormWidget extends StatefulWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onDataChanged;

  const ProfileFormWidget({
    super.key,
    required this.userData,
    required this.onDataChanged,
  });

  @override
  State<ProfileFormWidget> createState() => _ProfileFormWidgetState();
}

class _ProfileFormWidgetState extends State<ProfileFormWidget> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _apartmentController;
  String _selectedContactMethod = 'email';
  String _selectedCountryCode = '+1';
  bool _emailVerificationRequired = false;

  final List<Map<String, String>> _countryCodes = [
    {'code': '+1', 'country': 'US', 'flag': '🇺🇸'},
    {'code': '+44', 'country': 'UK', 'flag': '🇬🇧'},
    {'code': '+91', 'country': 'IN', 'flag': '🇮🇳'},
    {'code': '+971', 'country': 'AE', 'flag': '🇦🇪'},
    {'code': '+966', 'country': 'SA', 'flag': '🇸🇦'},
  ];

  final List<Map<String, String>> _contactMethods = [
    {'value': 'email', 'label': 'Email', 'icon': 'email'},
    {'value': 'phone', 'label': 'Phone', 'icon': 'phone'},
    {'value': 'both', 'label': 'Both', 'icon': 'contact_phone'},
  ];

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.userData["name"] as String? ?? "");
    _emailController =
        TextEditingController(text: widget.userData["email"] as String? ?? "");
    _phoneController = TextEditingController(
      text: (widget.userData["phone"] as String? ?? "")
          .replaceAll(RegExp(r'[^\d]'), ''),
    );
    _apartmentController = TextEditingController(
        text: widget.userData["apartmentNumber"] as String? ?? "");
    _selectedContactMethod =
        widget.userData["preferredContact"] as String? ?? 'email';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _apartmentController.dispose();
    super.dispose();
  }

  void _showCountryCodePicker() {
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
                'Select Country Code',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 2.h),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _countryCodes.length,
                  itemBuilder: (context, index) {
                    final country = _countryCodes[index];
                    return ListTile(
                      leading: Text(
                        country['flag']!,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(
                        '${country['country']} (${country['code']})',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                      trailing: _selectedCountryCode == country['code']
                          ? CustomIconWidget(
                              iconName: 'check',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 20,
                            )
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedCountryCode = country['code']!;
                        });
                        Navigator.pop(context);
                        widget.onDataChanged();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    Widget? suffix,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onChanged: (value) {
            widget.onDataChanged();
            onChanged?.call(value);
          },
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffix,
            filled: true,
            fillColor: readOnly
                ? AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5)
                : AppTheme.lightTheme.inputDecorationTheme.fillColor,
          ),
        ),
      ],
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
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Personal Information',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildFormField(
            label: 'Full Name',
            controller: _nameController,
            hintText: 'Enter your full name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          SizedBox(height: 2.h),
          _buildFormField(
            label: 'Email Address',
            controller: _emailController,
            hintText: 'Enter your email address',
            keyboardType: TextInputType.emailAddress,
            suffix: _emailVerificationRequired
                ? Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.warningLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Verify',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : CustomIconWidget(
                    iconName: 'verified',
                    color: AppTheme.successLight,
                    size: 20,
                  ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email address';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\$')
                  .hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _emailVerificationRequired = value != widget.userData["email"];
              });
            },
          ),
          SizedBox(height: 2.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Phone Number',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: _showCountryCodePicker,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.w, vertical: 1.5.h),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color:
                            AppTheme.lightTheme.inputDecorationTheme.fillColor,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _countryCodes.firstWhere(
                              (country) =>
                                  country['code'] == _selectedCountryCode,
                              orElse: () => _countryCodes[0],
                            )['flag']!,
                            style: const TextStyle(fontSize: 20),
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            _selectedCountryCode,
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                          SizedBox(width: 1.w),
                          CustomIconWidget(
                            iconName: 'keyboard_arrow_down',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        widget.onDataChanged();
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter phone number',
                        filled: true,
                        fillColor:
                            AppTheme.lightTheme.inputDecorationTheme.fillColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildFormField(
            label: 'Apartment Number',
            controller: _apartmentController,
            hintText: 'e.g., A-204',
            readOnly: true,
            suffix: CustomIconWidget(
              iconName: 'lock',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          SizedBox(height: 2.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Preferred Contact Method',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              Wrap(
                spacing: 2.w,
                children: _contactMethods.map((method) {
                  final isSelected = _selectedContactMethod == method['value'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedContactMethod = method['value']!;
                      });
                      widget.onDataChanged();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 4.w, vertical: 1.5.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
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
                            iconName: method['icon']!,
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                : AppTheme.lightTheme.colorScheme.onSurface,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            method['label']!,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.onPrimary
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
