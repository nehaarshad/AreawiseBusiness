import 'dart:io';
import 'package:ecommercefrontend/View_Model/SellerViewModels/sellerShopViewModel.dart';
import 'package:ecommercefrontend/View_Model/SharedViewModels/searchedShopViewMode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:ecommercefrontend/core/utils/notifyUtils.dart';
import 'package:ecommercefrontend/models/shopModel.dart';
import 'package:ecommercefrontend/repositories/ShopRepositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/utils/dialogueBox.dart';
import '../../models/categoryModel.dart';
import '../../repositories/categoriesRepository.dart';
import '../adminViewModels/ShopViewModel.dart';
import 'package:path/path.dart' as path;

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
  String? selectedArea;
  bool isCustomArea = false;
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
      selectedArea = shop.sector;
      state = AsyncValue.data(shop);
    } catch (e) {
      state = AsyncValue.error("No Internet Connection", StackTrace.empty);
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

      // Check if total images would exceed 8
      if (pickedFiles.isNotEmpty && images.length + pickedFiles.length > 1) {
        Utils.flushBarErrorMessage("Select only 1 Images", context);
        return;
      }

      if (pickedFiles.isNotEmpty) {
        // Compress all images first
        final List<File?> compressedFiles = await Future.wait(
          pickedFiles.map((xFile) async {
            try {
              final File file = File(xFile.path);
              return await compressImage(file, context);
            } catch (e) {
              print('Error processing image: $e');
              return null;
            }
          }),
        );

        // Filter out any null results from failed compressions
        final List<File> successfulCompressions = compressedFiles.whereType<File>().toList();

        // Create ProductImages objects
        final List<ShopImages> newImages = successfulCompressions
            .map((file) => ShopImages(imageUrl: null, file: file))
            .toList();

        // Add to images list
        images.addAll(newImages);

        print('Images count after adding: ${images.length}');

        // Final check (shouldn't be needed but good practice)
        if (images.length > 8) {
          Utils.flushBarErrorMessage("Select only 8 Images", context);
          // Remove excess images
          images.removeRange(8, images.length);
          return;
        }

        // Update state
        state.whenData((product) {
          if (product != null) {
            state = AsyncValue.data(product.copyWith(images: images));
          }
        });
      }
    } catch (e) {
      print('Error picking images: $e');
      Utils.flushBarErrorMessage("Error selecting images", context);
    }
  }

// Compress image before adding to state
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
      Utils.flushBarErrorMessage("Error compressing image", context);
      return null;
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

  void setArea(String? sector) {
    selectedArea = sector;
    state.whenData((shop) {
      if (shop != null) {
        state = AsyncValue.data(shop.copyWith(sector: sector));
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

  void toggleCustomArea(bool value) {
    isCustomArea = value;
    if (value) {
      selectedArea = null;
    }
  }


  void setCustomCategoryName(String name) {
    customCategoryName = name;
  }

  Future<void> updateShop({
    required String shopname,
    required String shopaddress,
    required String city,
    required String price,
    required String userid,
    required BuildContext context,
  }) async {
    try {
      if (images.isEmpty ) {
        Utils.flushBarErrorMessage("Please select image", context);
        return ;
      }

      final categoryName = isCustomCategory ? null : selectedCategory?.name;
      final sector = isCustomArea ? null : selectedArea;
      if (categoryName == null ) {
        Utils.flushBarErrorMessage("Select Existed category ", context);
        return;

      }

      if (sector == null ) {
        Utils.flushBarErrorMessage("Shop area is not provided", context);
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
      await DialogUtils.showSuccessDialog(context,"Shop updated successfully");

      Navigator.pop(context);
    } catch (e) {
      print(e);
      await DialogUtils.showErrorDialog(context,"Failed to update. Try later!");

    }
  }
}
