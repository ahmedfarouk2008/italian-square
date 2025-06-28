import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/complaint_category_widget.dart';
import './widgets/date_time_picker_widget.dart';
import './widgets/location_picker_widget.dart';
import './widgets/photo_upload_widget.dart';
import './widgets/priority_level_widget.dart';

class ComplaintSubmissionScreen extends StatefulWidget {
  const ComplaintSubmissionScreen({super.key});

  @override
  State<ComplaintSubmissionScreen> createState() =>
      _ComplaintSubmissionScreenState();
}

class _ComplaintSubmissionScreenState extends State<ComplaintSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;
  String? _selectedSubcategory;
  String _selectedPriority = 'Medium';
  String? _selectedLocation;
  List<String> _uploadedPhotos = [];
  DateTime _selectedDateTime = DateTime.now();
  bool _isAnonymous = false;
  bool _isSubmitting = false;

  // Mock data for complaint categories
  final Map<String, List<String>> _complaintCategories = {
    'Maintenance': [
      'Plumbing',
      'Electrical',
      'Air Conditioning',
      'Elevator',
      'General Repairs'
    ],
    'Noise': [
      'Construction Noise',
      'Neighbor Disturbance',
      'Traffic Noise',
      'Music/Party',
      'Other Noise'
    ],
    'Security': [
      'Gate Issues',
      'Lighting Problems',
      'Suspicious Activity',
      'Access Control',
      'Camera Issues'
    ],
    'Cleanliness': [
      'Garbage Collection',
      'Common Area Cleaning',
      'Pest Control',
      'Landscaping',
      'Pool Maintenance'
    ],
    'Other Residents': [
      'Parking Violations',
      'Pet Issues',
      'Rule Violations',
      'Harassment',
      'Property Damage'
    ],
  };

  final List<String> _priorityLevels = ['Low', 'Medium', 'High', 'Urgent'];
  final List<String> _locationOptions = [
    'Apartment 101',
    'Apartment 102',
    'Apartment 201',
    'Apartment 202',
    'Common Area - Lobby',
    'Common Area - Pool',
    'Common Area - Gym',
    'Common Area - Parking',
    'Common Area - Garden'
  ];

  @override
  void initState() {
    super.initState();
    _loadDraftData();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _loadDraftData() {
    // Mock draft loading functionality
    // In real app, this would load from SharedPreferences or local storage
  }

  void _saveDraft() {
    // Mock auto-save functionality
    // In real app, this would save to SharedPreferences or local storage
  }

  void _onCategoryChanged(String? category) {
    setState(() {
      _selectedCategory = category;
      _selectedSubcategory = null;
    });
    _saveDraft();
  }

  void _onSubcategoryChanged(String? subcategory) {
    setState(() {
      _selectedSubcategory = subcategory;
    });
    _saveDraft();
  }

  void _onPriorityChanged(String priority) {
    setState(() {
      _selectedPriority = priority;
    });
    _saveDraft();
  }

  void _onLocationChanged(String? location) {
    setState(() {
      _selectedLocation = location;
    });
    _saveDraft();
  }

  void _onPhotosChanged(List<String> photos) {
    setState(() {
      _uploadedPhotos = photos;
    });
    _saveDraft();
  }

  void _onDateTimeChanged(DateTime dateTime) {
    setState(() {
      _selectedDateTime = dateTime;
    });
    _saveDraft();
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Low':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'Medium':
        return Colors.orange;
      case 'High':
        return Colors.deepOrange;
      case 'Urgent':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  Future<void> _submitComplaint() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a complaint category')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Mock API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Generate mock complaint ID
      final complaintId =
          'CMP${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

      if (mounted) {
        _showSuccessDialog(complaintId);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit complaint: \$e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showSuccessDialog(String complaintId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              'Complaint Submitted',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your complaint has been successfully submitted.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Container(
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
                  Text(
                    'Complaint ID: $complaintId',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Expected Response: 24-48 hours',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/dashboard-screen');
            },
            child: const Text('Track Status'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetForm();
            },
            child: const Text('Submit Another'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _selectedCategory = null;
      _selectedSubcategory = null;
      _selectedPriority = 'Medium';
      _selectedLocation = null;
      _uploadedPhotos.clear();
      _selectedDateTime = DateTime.now();
      _isAnonymous = false;
    });
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Complaint'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
            size: 24,
          ),
        ),
        actions: [
          if (_isSubmitting)
            Container(
              margin: EdgeInsets.only(right: 4.w),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.appBarTheme.foregroundColor!,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress indicator
              Container(
                width: double.infinity,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _calculateProgress(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 3.h),

              // Complaint Category Section
              ComplaintCategoryWidget(
                categories: _complaintCategories,
                selectedCategory: _selectedCategory,
                selectedSubcategory: _selectedSubcategory,
                onCategoryChanged: _onCategoryChanged,
                onSubcategoryChanged: _onSubcategoryChanged,
              ),
              SizedBox(height: 3.h),

              // Priority Level Section
              PriorityLevelWidget(
                priorityLevels: _priorityLevels,
                selectedPriority: _selectedPriority,
                onPriorityChanged: _onPriorityChanged,
                getPriorityColor: _getPriorityColor,
              ),
              SizedBox(height: 3.h),

              // Location Section
              LocationPickerWidget(
                locationOptions: _locationOptions,
                selectedLocation: _selectedLocation,
                onLocationChanged: _onLocationChanged,
              ),
              SizedBox(height: 3.h),

              // Description Section
              Text(
                'Description *',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                maxLength: 500,
                decoration: const InputDecoration(
                  hintText:
                      'Please provide detailed information about your complaint...',
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please provide a description';
                  }
                  if (value.trim().length < 10) {
                    return 'Description must be at least 10 characters';
                  }
                  return null;
                },
                onChanged: (value) => _saveDraft(),
              ),
              SizedBox(height: 3.h),

              // Photo Upload Section
              PhotoUploadWidget(
                uploadedPhotos: _uploadedPhotos,
                onPhotosChanged: _onPhotosChanged,
              ),
              SizedBox(height: 3.h),

              // Date/Time Section
              DateTimePickerWidget(
                selectedDateTime: _selectedDateTime,
                onDateTimeChanged: _onDateTimeChanged,
              ),
              SizedBox(height: 3.h),

              // Anonymous Submission Toggle
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'visibility_off',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Submit Anonymously',
                            style: AppTheme.lightTheme.textTheme.titleSmall,
                          ),
                          Text(
                            'Your identity will be kept private',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isAnonymous,
                      onChanged: (value) {
                        setState(() {
                          _isAnonymous = value;
                        });
                        _saveDraft();
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitComplaint,
                  child: _isSubmitting
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            const Text('Submitting...'),
                          ],
                        )
                      : const Text('Submit Complaint'),
                ),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateProgress() {
    double progress = 0.0;

    if (_selectedCategory != null) progress += 0.2;
    if (_selectedSubcategory != null) progress += 0.1;
    if (_selectedLocation != null) progress += 0.2;
    if (_descriptionController.text.trim().isNotEmpty) progress += 0.3;
    if (_uploadedPhotos.isNotEmpty) progress += 0.1;
    if (_selectedPriority != 'Medium') progress += 0.1;

    return progress.clamp(0.0, 1.0);
  }
}
