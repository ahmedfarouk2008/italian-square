import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/announcements_carousel_widget.dart';
import './widgets/nearby_facilities_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/service_request_status_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int _currentTabIndex = 0;
  bool _isRefreshing = false;
  final int _notificationCount = 3;

  // Mock user data
  final Map<String, dynamic> _userData = {
    "name": "Ahmed Hassan",
    "apartmentNumber": "A-204",
    "lastUpdated": DateTime.now().subtract(Duration(minutes: 15)),
  };

  final List<Map<String, dynamic>> _tabItems = [
    {"icon": "home", "label": "Dashboard"},
    {"icon": "build", "label": "Services"},
    {"icon": "people", "label": "Community"},
    {"icon": "person", "label": "Profile"},
  ];

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dashboard updated successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showQuickServiceSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'Quick Service Request',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                children: [
                  _buildQuickServiceItem('Gate Entry', 'security', () {
                    Navigator.pop(context);
                    // Navigate to gate entry
                  }),
                  _buildQuickServiceItem('Complaint', 'report_problem', () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                        context, '/complaint-submission-screen');
                  }),
                  _buildQuickServiceItem('Emergency', 'emergency', () {
                    Navigator.pop(context);
                    // Handle emergency contact
                  }),
                  _buildQuickServiceItem('Maintenance', 'build', () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/services-directory-screen');
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickServiceItem(String title, String icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              size: 8.w,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.labelLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentTabIndex = index;
    });

    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        Navigator.pushNamed(context, '/services-directory-screen');
        break;
      case 2:
        // Navigate to community screen (not implemented)
        break;
      case 3:
        Navigator.pushNamed(context, '/profile-management-screen');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              // Header Section
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back,',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              _userData["name"] as String,
                              style: AppTheme.lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Apt. ${_userData["apartmentNumber"]}',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          IconButton(
                            onPressed: () {
                              // Handle notification tap
                            },
                            icon: CustomIconWidget(
                              iconName: 'notifications',
                              size: 6.w,
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                          if (_notificationCount > 0)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: EdgeInsets.all(1.w),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme.error,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 4.w,
                                  minHeight: 4.w,
                                ),
                                child: Text(
                                  _notificationCount.toString(),
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.onError,
                                    fontSize: 8.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Quick Actions Section
              SliverToBoxAdapter(
                child: QuickActionsWidget(
                  onGateEntryTap: () {
                    // Handle gate entry
                  },
                  onComplaintTap: () {
                    Navigator.pushNamed(
                        context, '/complaint-submission-screen');
                  },
                  onEmergencyTap: () {
                    // Handle emergency contact
                  },
                ),
              ),

              // Recent Announcements Section
              SliverToBoxAdapter(
                child: AnnouncementsCarouselWidget(),
              ),

              // Service Request Status Section
              SliverToBoxAdapter(
                child: ServiceRequestStatusWidget(),
              ),

              // Nearby Facilities Section
              SliverToBoxAdapter(
                child: NearbyFacilitiesWidget(),
              ),

              // Last Updated Info
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  child: Text(
                    'Last updated: ${_formatLastUpdated(_userData["lastUpdated"] as DateTime)}',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              // Bottom spacing
              SliverToBoxAdapter(
                child: SizedBox(height: 10.h),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showQuickServiceSheet,
        child: CustomIconWidget(
          iconName: 'add',
          size: 6.w,
          color: AppTheme.lightTheme.colorScheme.onTertiary,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: _tabItems.map((item) {
          return BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: item["icon"] as String,
              size: 5.w,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            activeIcon: CustomIconWidget(
              iconName: item["icon"] as String,
              size: 5.w,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            label: item["label"] as String,
          );
        }).toList(),
      ),
    );
  }

  String _formatLastUpdated(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}
