import 'dart:async';
import 'dart:io';
import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod/riverpod.dart';
import '../../core/utils/notifyUtils.dart';
import '../../models/UserDetailModel.dart';
import '../../repositories/UserDetailsRepositories.dart';
import '../../repositories/categoriesRepository.dart';
import '../SharedViewModels/getAllCategories.dart';
import 'package:flutter/material.dart';

import 'categoryStates.dart';

final categoryViewModelProvider = StateNotifierProvider<categoryViewModel, CategoryState>((
    ref,
    ) {
  return categoryViewModel(ref);
});

class categoryViewModel extends StateNotifier<CategoryState> {
  final Ref ref;
  final pickimage = ImagePicker();
  categoryViewModel(this.ref) : super(CategoryState()) {
    initialize();
  }
  File? uploadimage;
  bool loading = false;

  void resetState() {
    loading=false;
    state = CategoryState(isLoading: false,image: null); // Reset to initial state
  }

  Future<void> pickImages(BuildContext context) async {
    try {
      final XFile? pickedFiles = await pickimage.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFiles == null) {
        Utils.flushBarErrorMessage("Upload Ad Poster", context);
      }
      else {
        state = state.copyWith(image: File(pickedFiles.path));
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  Future<void> initialize() async {
    await getCategories();
  }
  Future<void> getCategories() async {
    try {
      List<Category?> categories = await ref.read(categoryProvider).getCategories();
      state = state.copyWith(category:categories);
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      print('Category id sent to be deleted! ${id}');
      await ref.read(categoryProvider).deleteCategory(id);
      getCategories();
      ref.invalidate(GetallcategoriesProvider);
      await ref.read(GetallcategoriesProvider.notifier).getCategories();
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> addCategory(String name,BuildContext context) async {
    try {
      print("${state.image?.uri} category image");

      await ref.read(categoryProvider).addCategory(name, state.image);
      state = state.copyWith(isLoading: false);
      ref.invalidate(GetallcategoriesProvider);
      await ref.read(GetallcategoriesProvider.notifier).getCategories();
      getCategories();
      uploadimage=null;


      Utils.toastMessage("Added Successfully!");
      Navigator.pop(context);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }


}
