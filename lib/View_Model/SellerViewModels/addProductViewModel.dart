import 'dart:io';
import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:ecommercefrontend/models/SubCategoryModel.dart';
import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:ecommercefrontend/models/shopModel.dart';
import 'package:ecommercefrontend/repositories/categoriesRepository.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/utils/dialogueBox.dart';
import '../../core/utils/notifyUtils.dart';
import '../../repositories/ShopRepositories.dart';
import '../../repositories/product_repositories.dart';
import '../SharedViewModels/getAllCategories.dart';
import '../SharedViewModels/productViewModels.dart';
import 'ProductStates.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

final addProductProvider = StateNotifierProvider.family<AddProductViewModel, ProductState, String>((ref, id,) {
      return AddProductViewModel(ref, id);
    });

class AddProductViewModel extends StateNotifier<ProductState> {
  final Ref ref;
  final String id;
  final ImagePicker pickImage = ImagePicker();

  AddProductViewModel(this.ref, this.id) : super(ProductState()) {
    getCategories();
    getUserShops();
  }

  bool isDisposed = false;

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  void resetState() {
    if (!isDisposed) {
      state =
          ProductState(isLoading: false, images: []); // Reset to initial state
      getCategories();
      getUserShops();
    }
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

  Future<void> getUserShops() async {
    try {
      state = state.copyWith(isLoading: true);
      final shops = await ref.read(shopProvider).getUserShop(id);

      state = state.copyWith(shops: shops, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      print('Error loading userShops: $e');
    }
  }

  Future<void> findSubcategories(String category) async {
    try {
      state = state.copyWith(isLoading: true);
      // Fetch subcategories for selected category
      final subcategories = await ref
          .read(categoryProvider)
          .FindSubCategories(category);
      state = state.copyWith(subcategories: subcategories, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      print('Error loading subcategories: $e');
    }
  }

  Future<void> pickImages(BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true); // Show loading while processing
      final List<XFile> pickedFiles = await pickImage.pickMultiImage();
      if (pickedFiles.isNotEmpty && state.images.length + pickedFiles.length <= 8) {
        final List<File> compressedImages = [];

        // Compress each selected image
        for (final xFile in pickedFiles) {
          final originalFile = File(xFile.path);
          final compressedFile = await compressImage(originalFile,context);

          if (compressedFile != null) {
            compressedImages.add(compressedFile);
            print('Compressed image: ${originalFile.lengthSync()} -> ${compressedFile.lengthSync()} bytes');
          }
        }

        final newImages = [...state.images, ...compressedImages];
        state = state.copyWith(images: newImages, isLoading: false);
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  // Compress image before adding to state
  Future<File?> compressImage(File file,BuildContext context) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(
        dir.path,
        '${DateTime.now().millisecondsSinceEpoch}_compressed.jpg',
      );

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 85, // Match backend optimization
        minWidth: 800,
        minHeight: 800,
        format: CompressFormat.jpeg,
      );

      return compressedFile != null ? File(compressedFile.path) : file;
    } catch (e) {
      print('Error picking images: $e');
      state = state.copyWith(isLoading: false);
      Utils.flushBarErrorMessage("Error selecting images", context);
    }
  }

  void removeImage(int index) {
    final newImages = List<File>.from(state.images)
      ..removeAt(index); //[..] Cascade or Chaining Opertor in list
    state = state.copyWith(images: newImages);
  }

  void setCategory(Category? category) {
    state = state.copyWith(
      selectedCategory: category,
      selectedSubcategory: null,
      subcategories: [],
    );
    if (category != null) {
      findSubcategories(category.name.toString());
    }
  }

  void setShop(ShopModel? shop) {
    state = state.copyWith(
      selectedShop: shop,
    );
  }

  void setSubcategory(Subcategory? subcategory) {
    state = state.copyWith(selectedSubcategory: subcategory);
  }

  void toggleCustomCategory(bool value) {
    state = state.copyWith(
      isCustomCategory: value,
      selectedCategory: value ? null : state.selectedCategory,
      customCategoryName: value ? null : state.customCategoryName,
    );
  }

  void toggleCustomShop(bool value) {
    state = state.copyWith(
      isCustomShop: value,
      selectedShop: value ? null : state.selectedShop,
    );
  }

  void toggleCustomSubcategory(bool value) {
    state = state.copyWith(
      isCustomSubcategory: value,
      selectedSubcategory: value ? null : state.selectedSubcategory,
      customSubcategoryName: value ? null : state.customSubcategoryName,
    );
  }

  void setCustomCategoryName(String? name) {
    state = state.copyWith(customCategoryName: name);
  }

  void setCustomSubcategoryName(String? name) {
    state = state.copyWith(customSubcategoryName: name);
  }

  Future<bool> addProduct({
    required String name,
    required String price,
    required String subtitle,
    required String description,
    required String stock,
    required String user,
    required String condition,
    required BuildContext context,
  }) async {
    try {


      print("User ID: $id");
      // Validate images
      if (state.images.isEmpty ) {
        Utils.flushBarErrorMessage("Please select images", context);
        return false;
      }

      // Validate price and stock
      final parsedPrice = int.tryParse(price);
      final parsedStock = int.tryParse(stock);

      if (parsedPrice == null || parsedStock == null) {
        throw Exception('Price and stock must be valid numbers');
      }
      //fetch shopId

      final shopId = state.isCustomShop ? null : state.selectedShop?.id.toString();
       if(shopId == null){
         Utils.flushBarErrorMessage("Select your Active Shop", context);
         return false;
       }
      // Validate category and subcategory
      final categoryName = state.isCustomCategory ? null : state.selectedCategory?.name;
      final subcategoryName = state.isCustomSubcategory ? null : state.selectedSubcategory?.name;

      if (categoryName == null || subcategoryName == null) {
         Utils.flushBarErrorMessage("Select existed category or subcategory", context);
          return false;

      }

      state = state.copyWith(isLoading: true);

      // Prepare data for the API request
      final data = {
        'name': name,
        'price': parsedPrice,
        'subtitle':subtitle,
        'description': description,
        'stock': parsedStock,
        'condition':condition,
        'productcategory': categoryName.trim(),
        'productsubcategory': subcategoryName.trim(),
      };


      // Log request body for debugging
      print("Request Body (name): ${data['name']} with type: ${data['name'].runtimeType}");
      print("Request Body (subtitle): ${data['subtitle']} with type: ${data['subtitle'].runtimeType}");
      print("Request Body (description): ${data['description']} with type: ${data['description'].runtimeType}");
      print("Request Body (price): ${data['price']} with type: ${data['price'].runtimeType}");
      print("Request Body (stock): ${data['stock']} with type: ${data['stock'].runtimeType}");
      print("Request Body (productcategory): ${data['productcategory']} with type: ${data['productcategory'].runtimeType}");
      print("Request Body (productsubcategory): ${data['productsubcategory']} with type: ${data['productsubcategory'].runtimeType}");
      print("shopID: ${shopId} with type: ${shopId.runtimeType}");
      // Add product to the backend
      ProductModel product=await ref.read(productProvider).addProduct(data, shopId, state.images.whereType<File>().toList());
      print("Api Response ${product}");
      try {
        // Invalidate the provider to refresh the product list
        ref.invalidate(sharedProductViewModelProvider);
        await ref.read(sharedProductViewModelProvider.notifier).getShopProduct(shopId);
        await ref.read(sharedProductViewModelProvider.notifier).getAllProduct('All');
        await ref.read(GetallcategoriesProvider.notifier);
        await ref.read(sharedProductViewModelProvider.notifier).getUserProduct(user);
      } catch (innerError) {
        print("Error refreshing product lists: $innerError");
        // Continue with success flow despite refresh errors
      }
     resetState();
      state = state.copyWith(isLoading: false,images: null);
     await DialogUtils.showSuccessDialog(context,"New product added");
      return true;
    } catch (e) {
      print(e);
      state = state.copyWith(
        isLoading: false,
      );
    await  DialogUtils.showErrorDialog(context,"Failed to add new Product");
      return false;
    }
  }

  Future<void> Cancel(String userId,BuildContext context) async{
    resetState();
    await Future.delayed(Duration(milliseconds: 500));
    Navigator.pop(context);
  }

}
