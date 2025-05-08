import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/utils/utils.dart';
import '../../models/ProductModel.dart';
import '../../models/SubCategoryModel.dart';
import '../../models/categoryModel.dart';
import '../../repositories/categoriesRepository.dart';
import '../../repositories/product_repositories.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../SharedViewModels/productViewModels.dart';

final updateProductProvider = StateNotifierProvider.family<UpdateProductViewModel, AsyncValue<ProductModel?>, String>((ref, id) {
  return UpdateProductViewModel(ref, id);
});

class UpdateProductViewModel extends StateNotifier<AsyncValue<ProductModel?>> {
  final Ref ref;
  final String id;
  final ImagePicker pickImage = ImagePicker();

  // State management for additional data
  List<ProductImages> images = [];
  List<Category> categories = [];
  Category? selectedCategory;
  bool isCustomCategory = false;
  String? customCategoryName;
  List<Subcategory> Subcategories = [];
  Subcategory? selectedSubCategory;
  bool isCustomSubCategory = false;
  String? customSubCategoryName;

  UpdateProductViewModel(this.ref, this.id)
    : super(const AsyncValue.loading()) {
    initValues(id);
    getCategories();
  }

  Future<void> initValues(String id) async {
    try {
      ProductModel product = await ref.read(productProvider).FindProduct(id);
      final tempDir = await getTemporaryDirectory();
      images = await Future.wait(
        product.images?.map((img) async {
              final response = await http.get(Uri.parse(img.imageUrl!));
              final file = File(
                '${tempDir.path}/${img.imageUrl!.split('/').last}',
              );
              await file.writeAsBytes(response.bodyBytes);
              return ProductImages(imageUrl: img.imageUrl, file: file);
            }).toList() ??
            [],
      );

      selectedCategory = product.category;
      selectedSubCategory = product.subcategory;
      state = AsyncValue.data(product);
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

  Future<void> findSubcategories(String category) async {
    try {
      state = AsyncValue.loading();
      // Fetch subcategories for selected category
      Subcategories = await ref
          .read(categoryProvider)
          .FindSubCategories(category);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      print('Error loading subcategories: $e');
    }
  }

  Future<void> pickImages(BuildContext context) async {
    try {
      final List<XFile> pickedFiles = await pickImage.pickMultiImage();
      if (pickedFiles.isNotEmpty && images.length + pickedFiles.length > 7) {
        Utils.flushBarErrorMessage("Select only 7 Images", context);
        return;
      }

      if (pickedFiles.isNotEmpty) {
        // Wrap new images in ShopImages with file property
        final newImages =
            pickedFiles.map((x) {
              final file = File(x.path);
              return ProductImages(imageUrl: null, file: file);
            }).toList();

        images.addAll(newImages);

        print('Images count after adding: ${images.length}'); // Debugging line
        if (images.length > 7) {
          Utils.flushBarErrorMessage("Select only 7 Images", context);
          return;
        }
        // Update state with combined images
        state.whenData((product) {
          if (product != null) {
            state = AsyncValue.data(product.copyWith(images: images));
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
    state.whenData((product) {
      if (product != null) {
        state = AsyncValue.data(product.copyWith(category: category));
      }
    });
  }

  void setSubcategory(Subcategory? subcategory) {
    selectedSubCategory = subcategory;
    state.whenData((product) {
      if (product != null) {
        state = AsyncValue.data(product.copyWith(subcategory: subcategory));
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

  void toggleCustomSubcategory(bool value) {
    isCustomSubCategory = value;
    if (value) {
      selectedSubCategory = null;
      customSubCategoryName = null;
    }
  }

  void setCustomCategoryName(String name) {
    customCategoryName = name;
  }

  void setCustomSubcategoryName(String name) {
    customSubCategoryName = name;
  }

  Future<void> updateProduct({
    required String name,
    required int price,
    required String subtitle,
    required String description,
    required int stock,
    required String shopId,
    required String user,
    required BuildContext context,
  }) async {
    try {
      print('Images count before update: ${images.length}');
      if (images.isEmpty || images.length > 7) {
        throw Exception('Please select 1 to 7 images');
      }
      state = const AsyncValue.loading();

      final data = {
        'name': name,
        'price': price,
        'subtitle':subtitle,
        'description': description,
        'stock': stock,
        'categories': selectedCategory?.name ?? customCategoryName,
        'subcategory': selectedSubCategory?.name ?? customSubCategoryName,
      };

      print("Request Body (name): ${data['name']} with type: ${data['name'].runtimeType}",);
      print("Request Body (subtitle): ${data['subtitle']} with type: ${data['subtitle'].runtimeType}",);
      print("Request Body (description): ${data['description']} with type: ${data['description'].runtimeType}",);
      print("Request Body (price): ${data['price']} with type: ${data['price'].runtimeType}",);
      print("Request Body (stock): ${data['stock']} with type: ${data['stock'].runtimeType}",);

      final imageFiles = images.map((img) => img.file!).toList();
      final response = await ref.read(productProvider).updateProduct(data, id.toString(), imageFiles);
      final updatedProduct = ProductModel.fromJson(response);
      print("Api Response ${updatedProduct}");
      try {
        // Invalidate the provider to refresh the product list
        ref.invalidate(sharedProductViewModelProvider);
        await ref.read(sharedProductViewModelProvider.notifier).getShopProduct(shopId);
        await ref.read(sharedProductViewModelProvider.notifier).getAllProduct('All');
        await ref.read(sharedProductViewModelProvider.notifier).getUserProduct(user);
      } catch (innerError) {
        print("Error refreshing product lists: $innerError");
        // Continue with success flow despite refresh errors
      }
      state = AsyncValue.data(updatedProduct);
     print("update product responce: ${updateProduct}");
      Utils.toastMessage("Updated Successfully!");
      Navigator.pop(context);
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
