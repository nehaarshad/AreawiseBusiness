import 'dart:io';
import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:ecommercefrontend/models/SubCategoryModel.dart';
import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:ecommercefrontend/repositories/categoriesRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/utils/utils.dart';
import '../../repositories/product_repositories.dart';
import 'ProductStates.dart';
import 'package:flutter/material.dart';

// final AddProductViewModelProvider=StateNotifierProvider.family<AddProductViewModel,AsyncValue<ProductModel?>,String>((ref,id){
//   return AddProductViewModel(ref,id);
// });
//
// class AddProductViewModel extends StateNotifier<AsyncValue<ProductModel?>>{
//   final Ref ref;
//   String id;
//   AddProductViewModel(this.ref,this.id):super(AsyncValue.loading()){
//
//   }
//
//   Future<void> Categories()async{
//     try {
//       List<Category?> category = await ref.read(categoryProvider).getCategories();
//       state = AsyncValue.data(category.isEmpty ? [] : category);
//     }catch(e){
//       state=AsyncValue.error(e, StackTrace.current);
//     }
//   }
//
//
//   Future<void> SubCategories(String Category)async{
//     try {
//       List<Subcategory?> subcategory = await ref.read(categoryProvider).FindSubCategories(Category);
//       state = AsyncValue.data(subcategory.isEmpty ? [] : subcategory);
//     }catch(e){
//       state=AsyncValue.error(e, StackTrace.current);
//     }
//   }
//
//
// }

// StateNotifierProvider for AddProductViewModel

final addProductProvider =
    StateNotifierProvider.family<AddProductViewModel, ProductState, String>((
      ref,
      id,
    ) {
      return AddProductViewModel(ref, id);
    });

class AddProductViewModel extends StateNotifier<ProductState> {
  final Ref ref;
  final String shopId;
  final ImagePicker pickImage = ImagePicker();

  AddProductViewModel(this.ref, this.shopId) : super(ProductState()) {
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
      final List<XFile> pickedFiles = await pickImage.pickMultiImage();
      if (pickedFiles.isNotEmpty &&
          state.images.length + pickedFiles.length > 7) {
        Utils.flushBarErrorMessage("Select only 4 Images", context);
        state = state.copyWith(images: state.images);
      }
      //atleast one image is selected & Previously and Newly Selected images are no more than 7
      if (pickedFiles.isNotEmpty &&
          state.images.length + pickedFiles.length <= 7) {
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
    state = state.copyWith(
      selectedCategory: category,
      selectedSubcategory: null,
      subcategories: [],
    );
    if (category != null) {
      findSubcategories(category.name.toString());
    }
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

  void toggleCustomSubcategory(bool value) {
    state = state.copyWith(
      isCustomSubcategory: value,
      selectedSubcategory: value ? null : state.selectedSubcategory,
      customSubcategoryName: value ? null : state.customSubcategoryName,
    );
  }

  void setCustomCategoryName(String name) {
    state = state.copyWith(customCategoryName: name);
  }

  void setCustomSubcategoryName(String name) {
    state = state.copyWith(customSubcategoryName: name);
  }

  Future<void> addProduct({
    required String name,
    required String price,
    required String description,
    required String stock,
    required BuildContext context,
  }) async {
    try {
      if (state.images.isEmpty || state.images.length > 7) {
        throw Exception('Please select 1 to 7 images');
      }
      state = state.copyWith(isLoading: true);
      final categoryName =
          state.isCustomCategory
              ? state.customCategoryName
              : state.selectedCategory?.name;
      final subcategoryName =
          state.isCustomSubcategory
              ? state.customSubcategoryName
              : state.selectedSubcategory?.name;

      if (categoryName == null || subcategoryName == null) {
        throw Exception('Category or subcategory Field is empty!');
      }

      final data = {
        'name': name,
        'price': int.tryParse(price),
        'description': description,
        'stock': int.tryParse(stock),
        'productcategory':
            state.selectedCategory?.name ?? state.customCategoryName,
        'productsubcategory':
            state.selectedSubcategory?.name ?? state.customSubcategoryName,
      };
      print(
        "Request Body (name): ${data['name']} with type: ${data['name'].runtimeType}",
      );
      print(
        "Request Body (description): ${data['description']} with type: ${data['description'].runtimeType}",
      );
      print(
        "Request Body (price): ${data['price']} with type: ${data['price'].runtimeType}",
      );
      print(
        "Request Body (stock): ${data['stock']} with type: ${data['stock'].runtimeType}",
      );

      final response = await ref
          .read(productProvider)
          .addProduct(
            data,
            shopId.toString(),
            state.images.whereType<File>().toList(),
          );
      final addproduct = ProductModel.fromJson(response);
      state = state.copyWith(
        product: AsyncValue.data(addproduct),
        isLoading: false,
      );
      Utils.flushBarErrorMessage("Product Created!", context);
      Navigator.pop(context);
    } catch (e) {
      Utils.flushBarErrorMessage('${e}', context);
      state = state.copyWith(
        product: AsyncValue.error(e, StackTrace.current),
        isLoading: false,
      );
    }
  }
}
