import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../../View_Model/SharedViewModels/locationSelectionViewModel.dart';
import '../../../core/services/locationService.dart';
import '../../../core/utils/colors.dart';

class LocationDisplayWidget extends ConsumerWidget {
  final VoidCallback? onLocationChange;

  const LocationDisplayWidget({
    super.key,
    this.onLocationChange,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocation = ref.watch(selectLocationViewModelProvider);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            color: Appcolors.baseColor,
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Location',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  currentLocation ?? 'All Areas',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () async {
              final result = await LocationService.showLocationSelector(context);
              if (result == true && onLocationChange != null) {
                onLocationChange!();
              }
            },
            icon: Icon(Icons.edit, size: 16.sp),
            label: Text(
              'Change',
              style: TextStyle(fontSize: 13.sp),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Appcolors.baseColor,
            ),
          ),
        ],
      ),
    );
  }
}