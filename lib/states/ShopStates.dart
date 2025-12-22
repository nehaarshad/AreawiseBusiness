import 'package:ecommercefrontend/models/shopModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/categoryModel.dart';

//Multiple state management at a time in riverpod done by using CopyWith Method
class ShopState {
  final AsyncValue<ShopModel?> shop;
  final List<dynamic> images;
  final List<Category> categories;
  final Category? selectedCategory;
  final bool isCustomCategory;
  final bool isLoading;
  final String? selectedArea;
  final bool isCustomArea;

  ShopState({
    this.shop = const AsyncValue.data(null),
    this.images = const [],
    this.categories = const [],
    this.selectedCategory,
    this.isCustomCategory = false,
    this.isLoading = false,
    this.isCustomArea=false,
    this.selectedArea,
  });

  ShopState copyWith({
    AsyncValue<ShopModel?>? shop,
    List<dynamic>? images,
    List<Category>? categories,
    Category? selectedCategory,
    bool? isCustomCategory,
    String? customCategoryName,
    bool? isLoading,
    bool? isCustomArea,
    String? selectedArea
  }) {
    return ShopState(
      shop: shop ?? this.shop,
      images: images ?? this.images,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isCustomCategory: isCustomCategory ?? this.isCustomCategory,
      isLoading: isLoading ?? this.isLoading,
      isCustomArea: isCustomArea ?? this.isCustomArea,
      selectedArea: selectedArea ?? this.selectedArea
    );
  }
}
