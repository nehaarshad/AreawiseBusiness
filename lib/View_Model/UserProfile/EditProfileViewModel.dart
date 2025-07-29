import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ecommercefrontend/repositories/UserDetailsRepositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/utils/routes/routes_names.dart';
import '../../core/utils/utils.dart';
import '../../models/UserDetailModel.dart';
import 'package:flutter/material.dart';

import '../adminViewModels/UserViewModel.dart';
import '../adminViewModels/searchUserViewModel.dart';
import '../auth/sessionmanagementViewModel.dart';
import 'UserProfileViewModel.dart';

final editProfileViewModelProvider = StateNotifierProvider.family<EditProfileViewModel, AsyncValue<UserDetailModel?>, String>((ref, id) {
  return EditProfileViewModel(ref, id);
});

class EditProfileViewModel extends StateNotifier<AsyncValue<UserDetailModel?>> {
  final Ref ref;
  String id;
  EditProfileViewModel(this.ref, this.id) : super(AsyncValue.loading()) {
    initValues(id);
  }


  final key = GlobalKey<FormState>();
  late TextEditingController username;
  late TextEditingController email;
  late TextEditingController contactnumber;
  late String currentRole;
  late String role;
  late TextEditingController sector;
  late TextEditingController city;
  late TextEditingController address;
  File? uploadimage;
  final pickimage = ImagePicker();
  bool loading = false;

  void initValues(String id) async {
    try {
      final StoredUserRole = ref.read(sessionProvider)?.role;
      currentRole=StoredUserRole!;
      UserDetailModel userdata = await ref.read(userProvider).getuserbyid(id);
      username = TextEditingController(text: userdata.username);
      email = TextEditingController(text: userdata.email);
      contactnumber = TextEditingController(text: userdata.contactnumber.toString());
      role =  userdata.role!;
      sector = TextEditingController(text: userdata.address?.sector ?? "");
      city = TextEditingController(text: userdata.address?.city ?? "");
      address = TextEditingController(text: userdata.address?.address ?? "");
      state = AsyncValue.data(userdata);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    contactnumber.dispose();
    sector.dispose();
    city.dispose();
    address.dispose();
    super.dispose();
  }

  Future<void> pickImages() async {
    final XFile? pickedimage = await pickimage.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedimage != null) {
      uploadimage = File(pickedimage.path);
      state = AsyncValue.data(
        state.value?.copyWith(image: ProfileImage(imageUrl: pickedimage.path)),
      );
    }
  }

  Future<void> updateUser(
    Map<String, dynamic> data,
    File? image,
    BuildContext context,
  ) async {
    try {
      final response = await ref.read(userProvider).updateUser(data, id, image);
      final updatedUser = UserDetailModel.fromJson(response);
      state = AsyncValue.data(updatedUser);
      Utils.toastMessage("User Updated Successfully!");
      await ref.read(UserProfileViewModelProvider(id).notifier).getuserdetail(id);
      await ref.read(UserViewModelProvider.notifier).getallusers();
      await ref.read(searchUserViewModelProvider.notifier).searchuser(data['username'].substring(0, 2));

      await Future.delayed(Duration(seconds: 1));
      Navigator.pop(context);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> ChangePassword(
      Map<String, dynamic> data,
      BuildContext context,
      ) async {
    try {
      final response = await ref.read(userProvider).changePassword(data, id);

      print(response);
      final message = response['message'] ?? 'Password change failed';
      print("Message ${message}");
      Utils.flushBarErrorMessage(message,context);
      await ref.read(UserProfileViewModelProvider(id).notifier).getuserdetail(id);
      await ref.read(UserViewModelProvider.notifier).getallusers();
      await ref.read(searchUserViewModelProvider.notifier).searchuser(data['username'].substring(0, 2));

      await Future.delayed(Duration(seconds: 1));

    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
