import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../View_Model/UserProfile/UserProfileViewModel.dart';
import '../../../models/UserDetailModel.dart';
import '../../../core/utils/colors.dart';

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
        return Container(
          width: width.w,
          height: height.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
// border: Border.all(color: Colors.grey.shade500, width: 2),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
              onError:
                  (e, stackTrace) => Icon(
                Icons.image_not_supported_outlined,
                size: 50.h,
                color: Colors.grey,
              ),
            ),
          ),
        );

      },
    );
  }
}

