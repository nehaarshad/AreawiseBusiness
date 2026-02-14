import 'dart:async';
import 'dart:io';
import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod/riverpod.dart';
import '../../core/utils/notifyUtils.dart';
import '../../repositories/categoriesRepository.dart';
import '../SharedViewModels/getAllCategories.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import '../../states/categoryStates.dart';
import 'categoriesViewModel.dart';

final editcategoryViewModelProvider = StateNotifierProvider<editcategoryViewModel, CategoryState>((
    ref,
    ) {
  return editcategoryViewModel(ref);
});

class editcategoryViewModel extends StateNotifier<CategoryState> {
  final Ref ref;
  final pickimage = ImagePicker();
  editcategoryViewModel(this.ref) : super(CategoryState()) {

  }
  File? uploadimage;
  bool loading = false;

  void resetState() {
    loading=false;
    state = CategoryState(isLoading: false,image: null); // Reset to initial state
  }

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

  Future<void> editCategory(String id,String name,String status,BuildContext context) async {
    try {
      print("${status} category ");

      await ref.read(categoryProvider).updateCategory(id,name,status, state.image);
      state = state.copyWith(isLoading: false);
      ref.invalidate(GetallcategoriesProvider);
      ref.invalidate(categoryViewModelProvider);
      await ref.read(GetallcategoriesProvider.notifier).getCategories();
      await ref.read(categoryViewModelProvider.notifier).getCategories();
      uploadimage=null;


      Utils.toastMessage("Added Successfully!");
      Navigator.pop(context);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }


}
