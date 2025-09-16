import 'dart:async';
import 'dart:io';
import 'package:ecommercefrontend/View_Model/adminViewModels/userState.dart';
import 'package:ecommercefrontend/repositories/UserDetailsRepositories.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/utils/dialogueBox.dart';
import '../../core/utils/notifyUtils.dart';
import '../../models/UserDetailModel.dart';
import 'package:flutter/material.dart';
import '../adminViewModels/UserViewModel.dart';
import 'package:path/path.dart' as path;

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

  Future<File?> compressImage(File file, BuildContext context) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(
        dir.path,
        '${DateTime.now().millisecondsSinceEpoch}_compressed.jpg',
      );

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 85,
        minWidth: 800,
        minHeight: 800,
        format: CompressFormat.jpeg,
      );

      return compressedFile != null ? File(compressedFile.path) : file;
    } catch (e) {
      print('Error compressing image: $e');
      state = state.copyWith(isLoading: false);
      Utils.flushBarErrorMessage("Error compressing image", context);
      return null;
    }
  }

  Future<void> pickImages(BuildContext context) async {
    try {
      final XFile? pickedFile = await pickimage.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile == null) {
        Utils.flushBarErrorMessage("Upload Ad Poster", context);
        return;
      }

      // Convert XFile to File
      final File file = File(pickedFile.path);
      final compressedFile = await compressImage(file, context);

      if (compressedFile != null) {
        state = state.copyWith(image: compressedFile);
      }
    } catch (e) {
      print('Error picking images: $e');
      Utils.flushBarErrorMessage("Error selecting images", context);
    }
  }

  void resetState() {
    loading=false;
    state = UserState(isLoading: false,image: null); // Reset to initial state
  }

  Future<void> Cancel(BuildContext context) async{
    uploadimage=null;
    resetState();
    await ref.read(UserViewModelProvider.notifier).getallusers();
    await Future.delayed(Duration(seconds: 1));
    Navigator.pop(context);
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
      resetState();
  //    state=state.copyWith(isLoading: false,image: null);
      await DialogUtils.showSuccessDialog(context,"New user added");

      await ref.read(UserViewModelProvider.notifier).getallusers();
      await Future.delayed(Duration(seconds: 1));
      Navigator.pop(context);
    } catch (e) {
      await DialogUtils.showErrorDialog(context,"Try Later!");
    }
  }
}
