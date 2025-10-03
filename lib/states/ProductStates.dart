import 'package:ecommercefrontend/models/shopModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ProductModel.dart';
import '../models/SubCategoryModel.dart';
import '../models/categoryModel.dart';

//Multiple state management at a time in riverpod done by using CopyWith Method
class ProductState {
  final AsyncValue<ProductModel?> product;
  final List<dynamic> images;
  final List<Category> categories;
  final List<ShopModel> shops;
  final List<Subcategory> subcategories;
  final Category? selectedCategory;
  final ShopModel? selectedShop;
  final Subcategory? selectedSubcategory;
  final bool isCustomCategory;
  final bool isCustomShop;
  final bool isCustomSubcategory;
  final String? customCategoryName;
  final String? customSubcategoryName;
  final bool isLoading;

  ProductState({
    this.product = const AsyncValue.data(null),
    this.images = const [],
    this.categories = const [],
    this.shops = const [],
    this.subcategories = const [],
    this.selectedCategory,
    this.selectedShop,
    this.selectedSubcategory,
    this.isCustomCategory = false,
    this.isCustomShop = false,
    this.isCustomSubcategory = false,
    this.customCategoryName,
    this.customSubcategoryName,
    this.isLoading = false,
  });

  ProductState copyWith({
    AsyncValue<ProductModel?>? product,
    List<dynamic>? images,
    List<Category>? categories,
    List<ShopModel>? shops,
    List<Subcategory>? subcategories,
    Category? selectedCategory,
    ShopModel? selectedShop,
    Subcategory? selectedSubcategory,
    bool? isCustomCategory,
    bool? isCustomShop,
    bool? isCustomSubcategory,
    String? customCategoryName,
    String? customSubcategoryName,
    bool? isLoading,
  }) {
    return ProductState(
      product: product ?? this.product,
      images: images ?? this.images,
      categories: categories ?? this.categories,
      shops: shops ??this.shops,
      subcategories: subcategories ?? this.subcategories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedShop: selectedShop ?? this.selectedShop,
      selectedSubcategory: selectedSubcategory ?? this.selectedSubcategory,
      isCustomCategory: isCustomCategory ?? this.isCustomCategory,
      isCustomShop: isCustomShop ?? this.isCustomShop,
      isCustomSubcategory: isCustomSubcategory ?? this.isCustomSubcategory,
      customCategoryName: customCategoryName ?? this.customCategoryName,
      customSubcategoryName:
          customSubcategoryName ?? this.customSubcategoryName,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
