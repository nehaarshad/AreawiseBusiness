import 'package:ecommercefrontend/core/services/locationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../View_Model/SharedViewModels/locationSelectionViewModel.dart';
import '../../../core/utils/colors.dart';

class LocationSettingsTile extends ConsumerWidget {
  const LocationSettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocation = ref.watch(selectLocationViewModelProvider);

    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Appcolors.baseColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          Icons.location_on,
          color: Appcolors.baseColor,
          size: 20.sp,
        ),
      ),
      title: Text(
        'Location',
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        currentLocation ?? 'Not set - Showing all areas',
        style: TextStyle(
          fontSize: 13.sp,
          color: Colors.grey[600],
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: () async {
        await LocationService.showLocationSelector(context);
      },
    );
  }
}