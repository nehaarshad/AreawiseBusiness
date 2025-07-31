import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:ecommercefrontend/repositories/product_repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchProductViewModelProvider = StateNotifierProvider<searchProductViewModel, AsyncValue<List<ProductModel?>>>((ref,) {
  return searchProductViewModel(ref);
});

class searchProductViewModel extends StateNotifier<AsyncValue<List<ProductModel?>>> {
  final Ref ref;
  searchProductViewModel(this.ref) : super(AsyncValue.loading());

  Future<void> searchProduct(String subcategory) async {
    try {
      state=AsyncValue.loading();
      List<ProductModel?> product = await ref.read(productProvider).searchProduct(subcategory);
      if (product.isEmpty) {
        state = const AsyncValue.data([]); // Explicit empty list
      } else {
        state = AsyncValue.data(product.where((p) => p != null).toList());
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

}