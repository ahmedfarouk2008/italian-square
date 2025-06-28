import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/service_card_widget.dart';
import './widgets/service_filter_bottom_sheet.dart';

class ServicesDirectoryScreen extends StatefulWidget {
  const ServicesDirectoryScreen({super.key});

  @override
  State<ServicesDirectoryScreen> createState() =>
      _ServicesDirectoryScreenState();
}

class _ServicesDirectoryScreenState extends State<ServicesDirectoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _selectedCategories = [];
  List<Map<String, dynamic>> _filteredServices = [];
  bool _isLoading = false;

  final List<Map<String, dynamic>> _services = [
    {
      "id": 1,
      "name": "License Renewal",
      "description":
          "Renew your driving license, vehicle registration, and other official documents",
      "category": "Government",
      "icon": "description",
      "responseTime": "2-3 days",
      "price": "\$50 - \$150",
      "provider": "Government Services Center",
      "contact": "+1-555-0101",
      "availability": "Available",
      "rating": 4.5,
      "color": Color(0xFF2B5A87),
      "isFavorite": false
    },
    {
      "id": 2,
      "name": "Carpentry",
      "description":
          "Professional wood work, furniture repair, and custom carpentry services",
      "category": "Home Maintenance",
      "icon": "build",
      "responseTime": "Same day",
      "price": "\$80 - \$200",
      "provider": "Master Carpenters Co.",
      "contact": "+1-555-0102",
      "availability": "Available",
      "rating": 4.8,
      "color": Color(0xFF8B4513),
      "isFavorite": true
    },
    {
      "id": 3,
      "name": "Plumbing",
      "description":
          "Emergency plumbing repairs, pipe installation, and water system maintenance",
      "category": "Home Maintenance",
      "icon": "plumbing",
      "responseTime": "1-2 hours",
      "price": "\$60 - \$180",
      "provider": "Quick Fix Plumbers",
      "contact": "+1-555-0103",
      "availability": "Available",
      "rating": 4.6,
      "color": Color(0xFF1E88E5),
      "isFavorite": false
    },
    {
      "id": 4,
      "name": "Satellite Installation",
      "description":
          "TV satellite setup, internet installation, and cable management services",
      "category": "Technology",
      "icon": "satellite",
      "responseTime": "Next day",
      "price": "\$100 - \$300",
      "provider": "TechConnect Solutions",
      "contact": "+1-555-0104",
      "availability": "Busy",
      "rating": 4.3,
      "color": Color(0xFF9C27B0),
      "isFavorite": false
    },
    {
      "id": 5,
      "name": "House Cleaning",
      "description":
          "Deep cleaning, regular maintenance, and specialized cleaning services",
      "category": "Cleaning",
      "icon": "cleaning_services",
      "responseTime": "Same day",
      "price": "\$40 - \$120",
      "provider": "Sparkle Clean Team",
      "contact": "+1-555-0105",
      "availability": "Available",
      "rating": 4.9,
      "color": Color(0xFF4CAF50),
      "isFavorite": true
    },
    {
      "id": 6,
      "name": "Painting",
      "description":
          "Interior and exterior painting, wall preparation, and color consultation",
      "category": "Home Maintenance",
      "icon": "format_paint",
      "responseTime": "2-3 days",
      "price": "\$150 - \$500",
      "provider": "Perfect Paint Pros",
      "contact": "+1-555-0106",
      "availability": "Available",
      "rating": 4.7,
      "color": Color(0xFFFF9800),
      "isFavorite": false
    },
    {
      "id": 7,
      "name": "Electrical Services",
      "description":
          "Electrical repairs, wiring installation, and safety inspections",
      "category": "Home Maintenance",
      "icon": "electrical_services",
      "responseTime": "1-3 hours",
      "price": "\$70 - \$250",
      "provider": "PowerUp Electricians",
      "contact": "+1-555-0107",
      "availability": "Available",
      "rating": 4.4,
      "color": Color(0xFFFFC107),
      "isFavorite": false
    },
    {
      "id": 8,
      "name": "Pest Control",
      "description":
          "Comprehensive pest elimination, prevention, and regular maintenance treatments",
      "category": "Health & Safety",
      "icon": "pest_control",
      "responseTime": "Same day",
      "price": "\$90 - \$200",
      "provider": "BugBusters Inc.",
      "contact": "+1-555-0108",
      "availability": "Available",
      "rating": 4.2,
      "color": Color(0xFF795548),
      "isFavorite": false
    }
  ];

  final List<String> _categories = [
    "All",
    "Government",
    "Home Maintenance",
    "Technology",
    "Cleaning",
    "Health & Safety"
  ];

  @override
  void initState() {
    super.initState();
    _filteredServices = List.from(_services);
    _selectedCategories.add("All");
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterServices() {
    setState(() {
      _filteredServices = _services.where((service) {
        final matchesSearch = service["name"]
                .toString()
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            service["description"]
                .toString()
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());

        final matchesCategory = _selectedCategories.contains("All") ||
            _selectedCategories.contains(service["category"]);

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceFilterBottomSheet(
        categories: _categories,
        selectedCategories: _selectedCategories,
        onCategoriesChanged: (categories) {
          setState(() {
            _selectedCategories.clear();
            _selectedCategories.addAll(categories);
            _filterServices();
          });
        },
      ),
    );
  }

  Future<void> _refreshServices() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      // Update availability status randomly for demo
      for (var service in _services) {
        if (service["id"] == 4) {
          service["availability"] = "Available";
        }
      }
      _filterServices();
    });
  }

  void _toggleFavorite(int serviceId) {
    setState(() {
      final serviceIndex = _services.indexWhere((s) => s["id"] == serviceId);
      if (serviceIndex != -1) {
        _services[serviceIndex]["isFavorite"] =
            !_services[serviceIndex]["isFavorite"];
        _filterServices();
      }
    });
  }

  void _requestService(Map<String, dynamic> service) {
    // Check authentication (mock check)
    final isAuthenticated = true; // This would be actual auth check

    if (!isAuthenticated) {
      Navigator.pushNamed(context, '/login-screen');
      return;
    }

    // Show service request dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Request ${service["name"]}',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service: ${service["name"]}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 1.h),
            Text(
              'Provider: ${service["provider"]}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 1.h),
            Text(
              'Response Time: ${service["responseTime"]}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 1.h),
            Text(
              'Price Range: ${service["price"]}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Text(
              'Your request will be submitted with your apartment details.',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Service request submitted for ${service["name"]}'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                ),
              );
            },
            child: const Text('Submit Request'),
          ),
        ],
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategories.clear();
      _selectedCategories.add("All");
      _filterServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Services Directory',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        actions: [
          IconButton(
            onPressed: () {
              // Focus search field
              FocusScope.of(context).requestFocus(FocusNode());
            },
            icon: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
              size: 24,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshServices,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: Column(
          children: [
            // Sticky Search Bar
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => _filterServices(),
                      decoration: InputDecoration(
                        hintText: 'Search services...',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'search',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  _filterServices();
                                },
                                icon: CustomIconWidget(
                                  iconName: 'clear',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.outline,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.outline,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: AppTheme.lightTheme.colorScheme.surface,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 1.5.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: _showFilterBottomSheet,
                      icon: CustomIconWidget(
                        iconName: 'filter_list',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Services Grid
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    )
                  : _filteredServices.isEmpty
                      ? _buildEmptyState()
                      : Padding(
                          padding: EdgeInsets.all(4.w),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 100.w > 600 ? 3 : 2,
                              crossAxisSpacing: 4.w,
                              mainAxisSpacing: 2.h,
                              childAspectRatio: 0.85,
                            ),
                            itemCount: _filteredServices.length,
                            itemBuilder: (context, index) {
                              final service = _filteredServices[index];
                              return ServiceCardWidget(
                                service: service,
                                onTap: () => _requestService(service),
                                onFavoriteToggle: () =>
                                    _toggleFavorite(service["id"]),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 64,
            ),
            SizedBox(height: 3.h),
            Text(
              'No services found',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your search or filters',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: _clearFilters,
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
