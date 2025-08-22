import 'dart:io';
import 'package:ecommercefrontend/View_Model/SellerViewModels/sellerShopViewModel.dart';
import 'package:ecommercefrontend/View_Model/SharedViewModels/searchedShopViewMode.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ecommercefrontend/core/utils/utils.dart';
import 'package:ecommercefrontend/models/shopModel.dart';
import 'package:ecommercefrontend/repositories/ShopRepositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/categoryModel.dart';
import '../../repositories/categoriesRepository.dart';
import '../adminViewModels/ShopViewModel.dart';

final updateShopProvider = StateNotifierProvider.family<UpdateShopViewModel, AsyncValue<ShopModel?>, String>((ref, id) {
  return UpdateShopViewModel(ref, id);
});

class UpdateShopViewModel extends StateNotifier<AsyncValue<ShopModel?>> {
  final Ref ref;
  final String id;
  final ImagePicker pickImage = ImagePicker();

  // State management for additional data
  List<ShopImages> images = [];
  List<Category> categories = [];
  Category? selectedCategory;
  bool isCustomCategory = false;
  String? customCategoryName;

  UpdateShopViewModel(this.ref, this.id) : super( AsyncValue.loading()) {
    initValues(id);
    getCategories();
  }

  Future<void> initValues(String id) async {
    try {
      ShopModel shop = await ref.read(shopProvider).findShop(id);

      // Download existing images and save them as local files
      final tempDir = await getTemporaryDirectory();
      images = await Future.wait(
        shop.images?.map((img) async {
              final response = await http.get(Uri.parse(img.imageUrl!));
              final file = File(
                '${tempDir.path}/${img.imageUrl!.split('/').last}',
              );
              await file.writeAsBytes(response.bodyBytes);
              return ShopImages(imageUrl: img.imageUrl, file: file);
            }).toList() ??
            [],
      );

      selectedCategory = shop.category;
      state = AsyncValue.data(shop);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      print('Error initializing Shop data: $e');
    }
  }

  Future<void> getCategories() async {
    try {
      categories = await ref.read(categoryProvider).getCategories();
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  Future<void> pickImages(BuildContext context) async {
    try {
      final List<XFile> pickedFiles = await pickImage.pickMultiImage();
      if (pickedFiles.isNotEmpty && images.length + pickedFiles.length > 4) {
        Utils.flushBarErrorMessage("Select only 4 Images", context);
        return;
      }

      if (pickedFiles.isNotEmpty) {
        // Wrap new images in ShopImages with file property
        final newImages =
            pickedFiles.map((x) {
              final file = File(x.path);
              return ShopImages(imageUrl: null, file: file);
            }).toList();

        images.addAll(newImages);
        print('Images count after adding: ${images.length}');
        if (images.length > 4) {
          Utils.flushBarErrorMessage("Select only 4 Images", context);
          return;
        }
        // Update state with combined images
        state.whenData((shop) {
          if (shop != null) {
            state = AsyncValue.data(shop.copyWith(images: images));
          }
        });
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  void removeImage(int index) {
    images.removeAt(index);
    // Update the shop model in state with the removed image
    state.whenData((shop) {
      if (shop != null) {
        state = AsyncValue.data(shop.copyWith(images: images));
      }
    });
  }

  void setCategory(Category? category) {
    selectedCategory = category;
    state.whenData((shop) {
      if (shop != null) {
        state = AsyncValue.data(shop.copyWith(category: category));
      }
    });
  }

  void toggleCustomCategory(bool value) {
    isCustomCategory = value;
    if (value) {
      selectedCategory = null;
      customCategoryName = null;
    }
  }

  void setCustomCategoryName(String name) {
    customCategoryName = name;
  }

  Future<void> updateShop({
    required String shopname,
    required String shopaddress,
    required String sector,
    required String city,
    required String price,
    required String userid,
    required BuildContext context,
  }) async {
    try {
      if (images.isEmpty || images.length > 4) {
        throw Exception('Please select 1 to 4 images');
      }

      final categoryName = isCustomCategory ? null : selectedCategory?.name;
      if (categoryName == null ) {
        Utils.flushBarErrorMessage("Select Existed category ", context);
        return;

      }

      final parsedPrice = int.tryParse(price);
      state = const AsyncValue.loading();

      final data = {
        'shopname': shopname,
        'shopaddress': shopaddress,
        'sector': sector,
        'city': city,
        'deliveryPrice':parsedPrice,
        'name': categoryName
      };

      print('Data send: ${data}');
      final imageFiles = images.map((img) => img.file!).toList();

      await ref.read(shopProvider).updateShop(data, id, imageFiles);
      ref.invalidate(sellerShopViewModelProvider(userid.toString()));
      await ref.read(sellerShopViewModelProvider(userid.toString()).notifier).getShops(userid.toString());
      await ref.read(searchShopViewModelProvider.notifier).searchShops(shopname.substring(0, 2));
      await ref.read(shopViewModelProvider.notifier).getShops();///update admin and buyer shopList
   //   state = AsyncValue.data(updatedShop);
      Navigator.pop(context);
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
