import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AnnouncementsCarouselWidget extends StatefulWidget {
  const AnnouncementsCarouselWidget({super.key});

  @override
  State<AnnouncementsCarouselWidget> createState() =>
      _AnnouncementsCarouselWidgetState();
}

class _AnnouncementsCarouselWidgetState
    extends State<AnnouncementsCarouselWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _announcements = [
    {
      "id": 1,
      "title": "Pool Maintenance Schedule",
      "description":
          "The swimming pool will be closed for maintenance from March 15-17. We apologize for any inconvenience.",
      "imageUrl":
          "https://images.pexels.com/photos/261102/pexels-photo-261102.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
      "priority": "medium",
    },
    {
      "id": 2,
      "title": "Community Event: Family BBQ",
      "description":
          "Join us for a family BBQ event this Saturday at 6 PM in the community garden. Food and drinks provided!",
      "imageUrl":
          "https://images.pexels.com/photos/1260968/pexels-photo-1260968.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "timestamp": DateTime.now().subtract(Duration(hours: 6)),
      "priority": "high",
    },
    {
      "id": 3,
      "title": "Parking Regulations Update",
      "description":
          "New parking regulations will be enforced starting next month. Please review the updated guidelines.",
      "imageUrl":
          "https://images.pexels.com/photos/164634/pexels-photo-164634.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "timestamp": DateTime.now().subtract(Duration(days: 1)),
      "priority": "low",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return AppTheme.errorLight;
      case 'medium':
        return AppTheme.warningLight;
      case 'low':
        return AppTheme.successLight;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Announcements',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to all announcements
                  },
                  child: Text('View All'),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 25.h,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _announcements.length,
              itemBuilder: (context, index) {
                final announcement = _announcements[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.shadow,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Stack(
                            children: [
                              CustomImageWidget(
                                imageUrl: announcement["imageUrl"] as String,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 2.w,
                                right: 2.w,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 0.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getPriorityColor(
                                        announcement["priority"] as String),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    (announcement["priority"] as String)
                                        .toUpperCase(),
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 8.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        announcement["title"] as String,
                                        style: AppTheme
                                            .lightTheme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      _formatTimestamp(announcement["timestamp"]
                                          as DateTime),
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                Expanded(
                                  child: Text(
                                    announcement["description"] as String,
                                    style:
                                        AppTheme.lightTheme.textTheme.bodySmall,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _announcements.length,
              (index) => Container(
                width: 2.w,
                height: 2.w,
                margin: EdgeInsets.symmetric(horizontal: 1.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
