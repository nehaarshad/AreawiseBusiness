import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../View_Model/UserProfile/UserProfileViewModel.dart';
import '../../../models/UserDetailModel.dart';
import 'colors.dart';

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
      loading: () => Center(
        child: CircularProgressIndicator(color: Appcolors.blackColor),),
      error:(err, stack) => Center(child: Text('Error: $err')),
      data: (userData) {
        if (userData == null) {
          return const Center(child: Text("User not found"));
        }

        final imageUrl = ref.read(UserProfileViewModelProvider(user.id.toString()).notifier)
            .getProfileImage(userData);
print(imageUrl);
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
// border: Border.all(color: Colors.grey.shade500, width: 2),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
              onError:
                  (e, stackTrace) => Icon(
                Icons.image_not_supported_outlined,
                size: 50,
                color: Colors.grey,
              ),
            ),
          ),
        );

      },
    );
  }
}

