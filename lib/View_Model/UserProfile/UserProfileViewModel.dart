import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/UserDetailModel.dart';
import '../../repositories/UserDetailsRepositories.dart';

final UserProfileViewModelProvider = StateNotifierProvider.family<
  UserProfileViewModel,
  AsyncValue<UserDetailModel?>,
  String
>((ref, id) {
  return UserProfileViewModel(ref, id);
});

class UserProfileViewModel extends StateNotifier<AsyncValue<UserDetailModel?>> {
  final Ref ref;
  final String id;

  UserProfileViewModel(this.ref, this.id) : super(const AsyncValue.loading()) {
    getuserdetail(id);
  }

  Future<void> getuserdetail(String userId) async {
    try {
      UserDetailModel userdata = await ref.read(userProvider).getuserbyid(id);
      print(userdata);
      state = AsyncValue.data(userdata);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  String getProfileImage(UserDetailModel? user) {
    String imageUrl =
        user?.image?.imageUrl != null && user!.image!.imageUrl!.isNotEmpty
            ? user.image!.imageUrl!
            : "https://th.bing.com/th/id/R.8e2c571ff125b3531705198a15d3103c?rik=gzhbzBpXBa%2bxMA&riu=http%3a%2f%2fpluspng.com%2fimg-png%2fuser-png-icon-big-image-png-2240.png&ehk=VeWsrun%2fvDy5QDv2Z6Xm8XnIMXyeaz2fhR3AgxlvxAc%3d&risl=&pid=ImgRaw&r=0";
    return imageUrl;
  }
}
