import 'dart:async';
import 'dart:io';
import 'package:ecommercefrontend/View_Model/adminViewModels/userState.dart';
import 'package:ecommercefrontend/repositories/UserDetailsRepositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/utils/utils.dart';
import '../../models/UserDetailModel.dart';
import 'package:flutter/material.dart';
import '../adminViewModels/UserViewModel.dart';

final addUserViewModelProvider = StateNotifierProvider<addUserViewModel,UserState>((ref) {
  return addUserViewModel(ref);
});

class addUserViewModel extends StateNotifier<UserState> {
  final Ref ref;
  final pickimage = ImagePicker();
  addUserViewModel(this.ref) : super(UserState()) {

  }

  File? uploadimage;
  bool loading = false;

  Future<void> pickImages() async {
    final XFile? pickedimage = await pickimage.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedimage != null) {
      uploadimage = File(pickedimage.path);
      Utils.toastMessage("Uploading...");
      state = state.copyWith(image: uploadimage);
    }
  }


  Future<void> addUser(
      Map<String, dynamic> data,
      BuildContext context,
      ) async
  {
    try {
      print("${state.image?.uri} user image");
      final response = await ref.read(userProvider).addUser(data, state.image);
      final newUser = UserDetailModel.fromJson(response);
      uploadimage=null;
      Utils.toastMessage("User Added Successfully!");
      await ref.read(UserViewModelProvider.notifier).getallusers();
      await Future.delayed(Duration(seconds: 1));
      Navigator.pop(context);
    } catch (e) {
      state = state.copyWith(user: AsyncValue.error(e, StackTrace.current));
    }
  }
}
