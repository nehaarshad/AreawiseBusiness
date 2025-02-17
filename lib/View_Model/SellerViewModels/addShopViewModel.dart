import 'dart:io';
import 'package:ecommercefrontend/View_Model/SellerViewModels/ShopStates.dart';
import 'package:flutter/material.dart';
import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:ecommercefrontend/models/shopModel.dart';
import 'package:ecommercefrontend/repositories/ShopRepositories.dart';
import 'package:ecommercefrontend/repositories/categoriesRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/utils/utils.dart';
import '../../repositories/product_repositories.dart';
import 'ProductStates.dart';

final addShopProvider =
    StateNotifierProvider.family<AddShopViewModel, ShopState, String>((
      ref,
      id,
    ) {
      return AddShopViewModel(ref, id);
    });

class AddShopViewModel extends StateNotifier<ShopState> {
  final Ref ref;
  final String shopId;
  final ImagePicker pickImage = ImagePicker();

  AddShopViewModel(this.ref, this.shopId) : super(ShopState()) {
    getCategories();
  }

  Future<void> getCategories() async {
    try {
      state = state.copyWith(isLoading: true);
      final categories = await ref.read(categoryProvider).getCategories();
      state = state.copyWith(categories: categories, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      print('Error loading categories: $e');
    }
  }

  Future<void> pickImages(BuildContext context) async {
    try {
      final List<XFile> pickedFiles = await pickImage.pickMultiImage();
      if (pickedFiles.isNotEmpty &&
          state.images.length + pickedFiles.length > 4) {
        Utils.flushBarErrorMessage("Select only 4 Images", context);
        state = state.copyWith(images: state.images);
      }
      //atleast one image is selected & Previously and Newly Selected images are no more than 7
      if (pickedFiles.isNotEmpty &&
          state.images.length + pickedFiles.length <= 4) {
        // [...] "Spread Operator" used to combine 2 lists (Previously and Newly Selected images lists)
        final newImages = [
          ...state.images,
          ...pickedFiles.map((x) => File(x.path)),
        ];
        state = state.copyWith(images: newImages);
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  void removeImage(int index) {
    final newImages = List<File>.from(state.images)
      ..removeAt(index); //[..] Cascade or Chaining Opertor in list
    state = state.copyWith(images: newImages);
  }

  void setCategory(Category? category) {
    state = state.copyWith(selectedCategory: category);
  }

  void toggleCustomCategory(bool value) {
    state = state.copyWith(
      isCustomCategory: value, //new category (true)
      selectedCategory:
          value
              ? null
              : state
                  .selectedCategory, //null -> previously selected predefined category
      customCategoryName:
          value
              ? null
              : state
                  .customCategoryName, //null to initialize its value in other function
    );
  }

  void setCustomCategoryName(String name) {
    state = state.copyWith(customCategoryName: name);
  }

  Future<void> addShop({
    required String shopname,
    required String shopaddress,
    required String sector,
    required String city,
  }) async {
    try {
      if (state.images.isEmpty || state.images.length > 4) {
        throw Exception('Please select 1 to 4 images');
      }
      state = state.copyWith(isLoading: true);
      final categoryName =
          state.isCustomCategory
              ? state.customCategoryName
              : state.selectedCategory?.name;
      if (categoryName == null) {
        throw Exception('Category Field is empty!');
      }

      final data = {
        'shopname': shopname,
        'shopaddress': shopaddress,
        'sector': sector,
        'city': city,
        'name': categoryName,
      };

      final response = await ref
          .read(shopProvider)
          .addShop(data, shopId, state.images.whereType<File>().toList());
      final addshop = ShopModel.fromJson(response);

      state = state.copyWith(shop: AsyncValue.data(addshop), isLoading: false);
    } catch (e) {
      state = state.copyWith(
        shop: AsyncValue.error(e, StackTrace.current),
        isLoading: false,
      );
    }
  }
}
