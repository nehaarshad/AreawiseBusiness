import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../View_Model/UserProfile/UserProfileViewModel.dart';
import '../../../models/UserDetailModel.dart';

class ProfileImageWidget extends ConsumerWidget {
  final UserDetailModel user;
  final double height;
  final double weidth;

  const ProfileImageWidget({
    required this.user,
    required this.height,
    required this.weidth,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modelobject =  ref.watch(
      UserProfileViewModelProvider(user.id.toString()).notifier,
    );
    final imageUrl = modelobject.getProfileImage(user); //retrive image

    return Container(
      width: weidth,
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
  }
}
