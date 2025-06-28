import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NearbyFacilitiesWidget extends StatelessWidget {
  const NearbyFacilitiesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> facilities = [
      {
        "id": 1,
        "name": "Carrefour Market",
        "type": "market",
        "distance": 0.8,
        "isOpen": true,
        "openingHours": "24/7",
        "rating": 4.2,
        "imageUrl":
            "https://images.pexels.com/photos/264636/pexels-photo-264636.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "address": "Dubai Marina Mall",
      },
      {
        "id": 2,
        "name": "Life Pharmacy",
        "type": "pharmacy",
        "distance": 0.5,
        "isOpen": true,
        "openingHours": "8:00 AM - 12:00 AM",
        "rating": 4.5,
        "imageUrl":
            "https://images.pexels.com/photos/5327585/pexels-photo-5327585.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "address": "Marina Walk",
      },
      {
        "id": 3,
        "name": "Spinneys",
        "type": "market",
        "distance": 1.2,
        "isOpen": false,
        "openingHours": "7:00 AM - 11:00 PM",
        "rating": 4.0,
        "imageUrl":
            "https://images.pexels.com/photos/1005638/pexels-photo-1005638.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "address": "JBR The Beach",
      },
      {
        "id": 4,
        "name": "Aster Clinic",
        "type": "pharmacy",
        "distance": 0.9,
        "isOpen": true,
        "openingHours": "8:00 AM - 10:00 PM",
        "rating": 4.3,
        "imageUrl":
            "https://images.pexels.com/photos/5327921/pexels-photo-5327921.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "address": "Marina Plaza",
      },
    ];

    // Sort by distance
    facilities.sort(
        (a, b) => (a["distance"] as double).compareTo(b["distance"] as double));

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nearby Facilities',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to map view
                },
                child: Text('Map View'),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: facilities.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final facility = facilities[index];
              return _buildFacilityCard(facility);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityCard(Map<String, dynamic> facility) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomImageWidget(
              imageUrl: facility["imageUrl"] as String,
              width: 15.w,
              height: 15.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        facility["name"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildStatusIndicator(facility["isOpen"] as bool),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: _getFacilityIcon(facility["type"] as String),
                      size: 3.w,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      (facility["type"] as String).toUpperCase(),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName: 'location_on',
                      size: 3.w,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${facility["distance"]} km',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  facility["address"] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        final rating = facility["rating"] as double;
                        return CustomIconWidget(
                          iconName:
                              index < rating.floor() ? 'star' : 'star_border',
                          size: 3.w,
                          color: Colors.amber,
                        );
                      }),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      facility["rating"].toString(),
                      style: AppTheme.lightTheme.textTheme.labelSmall,
                    ),
                    Spacer(),
                    Text(
                      facility["openingHours"] as String,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 2.w),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  // Open directions
                },
                icon: CustomIconWidget(
                  iconName: 'directions',
                  size: 5.w,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Call facility
                },
                icon: CustomIconWidget(
                  iconName: 'phone',
                  size: 5.w,
                  color: AppTheme.successLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(bool isOpen) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: isOpen
            ? AppTheme.successLight.withValues(alpha: 0.1)
            : AppTheme.errorLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 2.w,
            height: 2.w,
            decoration: BoxDecoration(
              color: isOpen ? AppTheme.successLight : AppTheme.errorLight,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 1.w),
          Text(
            isOpen ? 'Open' : 'Closed',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: isOpen ? AppTheme.successLight : AppTheme.errorLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getFacilityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'market':
        return 'shopping_cart';
      case 'pharmacy':
        return 'local_pharmacy';
      case 'hospital':
        return 'local_hospital';
      case 'restaurant':
        return 'restaurant';
      default:
        return 'place';
    }
  }
}
