import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../View_Model/UserProfile/UserProfileViewModel.dart';
import '../../../models/UserDetailModel.dart';
import 'loadingState.dart';

class ProfileImageWidget extends ConsumerWidget {
  final UserDetailModel user;
  final double height;
  final double width;

  const ProfileImageWidget({
    required this.user,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(
      UserProfileViewModelProvider(user.id.toString()),
    );

    return userProfileAsync.when(
      loading: () =>  Center(
        child: SizedBox(
          height: 100.h,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error:(err, stack) => Center(child: Text('Error: $err')),
      data: (userData) {
        if (userData == null) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0.h),
              child: Text(
                "User not found",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        final imageUrl = ref.read(UserProfileViewModelProvider(user.id.toString()).notifier)
            .getProfileImage(userData);
print(imageUrl);
        return CachedNetworkImage(
          imageUrl: imageUrl,
          imageBuilder: (context, imageProvider) => Container(
            width: width.w,
            height: height.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            width: width.w,
            height: height.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: Icon(
              Icons.image_not_supported_outlined,
              size: 50.h,
              color: Colors.grey,
            ),
          ),
        );

      },
    );
  }
}

