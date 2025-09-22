import '../../models/categoryModel.dart';

//Multiple state management at a time in riverpod done by using CopyWith Method
class CartState {
  final List<Category?>? category;
  final bool isLoading;

  CartState({
    this.category = null,
    this.isLoading = false,
  });

  CartState copyWith({
    List<Category?>? category,
    bool? isLoading,
  }) {
    return CartState(
      category: category ?? this.category,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
