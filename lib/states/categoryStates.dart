import 'dart:io';
import '../models/categoryModel.dart';

//Multiple state management at a time in riverpod done by using CopyWith Method
class CategoryState {
  final List<Category?>? category;
  final File? image;
  final bool isLoading;

  CategoryState({
    this.category = null,
    this.image = null,
    this.isLoading = false,
  });

  CategoryState copyWith({
    List<Category?>? category,
    File? image,
    bool? isLoading,
  }) {
    return CategoryState(
      category: category ?? this.category,
      image: image ?? this.image,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
