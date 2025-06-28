import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ServiceRequestStatusWidget extends StatelessWidget {
  const ServiceRequestStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> serviceRequests = [
      {
        "id": 1,
        "type": "Plumbing",
        "description": "Kitchen sink faucet repair",
        "status": "in_progress",
        "progress": 0.7,
        "requestDate": DateTime.now().subtract(Duration(days: 2)),
        "estimatedCompletion": DateTime.now().add(Duration(days: 1)),
        "providerName": "Ahmed Plumbing Services",
        "providerPhone": "+971-50-123-4567",
      },
      {
        "id": 2,
        "type": "Electrical",
        "description": "Living room light fixture installation",
        "status": "pending",
        "progress": 0.2,
        "requestDate": DateTime.now().subtract(Duration(hours: 8)),
        "estimatedCompletion": DateTime.now().add(Duration(days: 3)),
        "providerName": "ElectroFix Dubai",
        "providerPhone": "+971-50-987-6543",
      },
      {
        "id": 3,
        "type": "Cleaning",
        "description": "Deep cleaning service",
        "status": "completed",
        "progress": 1.0,
        "requestDate": DateTime.now().subtract(Duration(days: 5)),
        "estimatedCompletion": DateTime.now().subtract(Duration(days: 1)),
        "providerName": "CleanPro Services",
        "providerPhone": "+971-50-555-1234",
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Service Requests',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all service requests
                },
                child: Text('View All'),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: serviceRequests.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final request = serviceRequests[index];
              return _buildServiceRequestCard(context, request);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceRequestCard(
      BuildContext context, Map<String, dynamic> request) {
    return GestureDetector(
      onLongPress: () {
        _showQuickActions(context, request);
      },
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: _getServiceTypeColor(request["type"] as String)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: _getServiceTypeIcon(request["type"] as String),
                    size: 5.w,
                    color: _getServiceTypeColor(request["type"] as String),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request["type"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        request["description"] as String,
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(request["status"] as String),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progress',
                        style: AppTheme.lightTheme.textTheme.labelMedium,
                      ),
                      SizedBox(height: 0.5.h),
                      LinearProgressIndicator(
                        value: request["progress"] as double,
                        backgroundColor: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getStatusColor(request["status"] as String),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  '${((request["progress"] as double) * 100).toInt()}%',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(request["status"] as String),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'person',
                  size: 4.w,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    request["providerName"] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ),
                CustomIconWidget(
                  iconName: 'schedule',
                  size: 4.w,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: 2.w),
                Text(
                  _formatDate(request["estimatedCompletion"] as DateTime),
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        _getStatusText(status),
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: _getStatusColor(status),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showQuickActions(BuildContext context, Map<String, dynamic> request) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(bottom: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility',
                size: 5.w,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              title: Text('View Details'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to request details
              },
            ),
            if (request["status"] != "completed")
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'cancel',
                  size: 5.w,
                  color: AppTheme.errorLight,
                ),
                title: Text('Cancel Request'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle cancel request
                },
              ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'phone',
                size: 5.w,
                color: AppTheme.successLight,
              ),
              title: Text('Contact Provider'),
              onTap: () {
                Navigator.pop(context);
                // Handle contact provider
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getServiceTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'plumbing':
        return Colors.blue;
      case 'electrical':
        return Colors.orange;
      case 'cleaning':
        return Colors.green;
      case 'carpentry':
        return Colors.brown;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _getServiceTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'plumbing':
        return 'plumbing';
      case 'electrical':
        return 'electrical_services';
      case 'cleaning':
        return 'cleaning_services';
      case 'carpentry':
        return 'carpenter';
      default:
        return 'build';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return AppTheme.warningLight;
      case 'in_progress':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'completed':
        return AppTheme.successLight;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      default:
        return 'Unknown';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays > 0) {
      return '${difference.inDays}d left';
    } else if (difference.inDays == 0) {
      return 'Today';
    } else {
      return 'Completed';
    }
  }
}
