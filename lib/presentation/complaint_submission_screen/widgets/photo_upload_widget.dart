import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PhotoUploadWidget extends StatelessWidget {
  final List<String> uploadedPhotos;
  final Function(List<String>) onPhotosChanged;

  const PhotoUploadWidget({
    super.key,
    required this.uploadedPhotos,
    required this.onPhotosChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Photos',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(width: 2.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Optional',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Text(
          'Add photos to help us understand the issue better (Max 5 photos)',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),

        // Photo upload buttons
        Row(
          children: [
            Expanded(
              child: _buildUploadButton(
                context,
                'Camera',
                'camera_alt',
                () => _addPhoto(context, 'camera'),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildUploadButton(
                context,
                'Gallery',
                'photo_library',
                () => _addPhoto(context, 'gallery'),
              ),
            ),
          ],
        ),

        // Uploaded photos grid
        if (uploadedPhotos.isNotEmpty) ...[
          SizedBox(height: 3.h),
          Text(
            'Uploaded Photos (${uploadedPhotos.length}/5)',
            style: AppTheme.lightTheme.textTheme.labelMedium,
          ),
          SizedBox(height: 1.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2.w,
              mainAxisSpacing: 2.w,
              childAspectRatio: 1,
            ),
            itemCount: uploadedPhotos.length,
            itemBuilder: (context, index) {
              return _buildPhotoThumbnail(
                  context, uploadedPhotos[index], index);
            },
          ),
        ],

        // Upload guidelines
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Photo Guidelines',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              _buildGuideline('Clear, well-lit photos work best'),
              _buildGuideline('Show the issue from multiple angles'),
              _buildGuideline('Include surrounding context if relevant'),
              _buildGuideline('Maximum file size: 10MB per photo'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUploadButton(
    BuildContext context,
    String label,
    String iconName,
    VoidCallback onTap,
  ) {
    final canUpload = uploadedPhotos.length < 5;

    return GestureDetector(
      onTap: canUpload ? onTap : null,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: canUpload
              ? AppTheme.lightTheme.colorScheme.surface
              : AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: canUpload
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.5),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: canUpload
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.5),
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: canUpload
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoThumbnail(
      BuildContext context, String photoUrl, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: CustomImageWidget(
              imageUrl: photoUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 1.w,
            right: 1.w,
            child: GestureDetector(
              onTap: () => _removePhoto(index),
              child: Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.error,
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.onError,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideline(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 0.5.h),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addPhoto(BuildContext context, String source) {
    // Mock photo URLs for demonstration
    final List<String> mockPhotos = [
      'https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&cs=tinysrgb&w=800',
      'https://images.pexels.com/photos/2724749/pexels-photo-2724749.jpeg?auto=compress&cs=tinysrgb&w=800',
      'https://images.pexels.com/photos/1571453/pexels-photo-1571453.jpeg?auto=compress&cs=tinysrgb&w=800',
      'https://images.pexels.com/photos/2724748/pexels-photo-2724748.jpeg?auto=compress&cs=tinysrgb&w=800',
      'https://images.pexels.com/photos/1571457/pexels-photo-1571457.jpeg?auto=compress&cs=tinysrgb&w=800',
    ];

    if (uploadedPhotos.length < 5) {
      final newPhoto = mockPhotos[uploadedPhotos.length % mockPhotos.length];
      final updatedPhotos = List<String>.from(uploadedPhotos)..add(newPhoto);
      onPhotosChanged(updatedPhotos);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Photo added from $source'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _removePhoto(int index) {
    final updatedPhotos = List<String>.from(uploadedPhotos)..removeAt(index);
    onPhotosChanged(updatedPhotos);
  }
}
