import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:ecommercefrontend/repositories/product_repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ProductManagementViewModelProvider = StateNotifierProvider<ProductManagementViewModel, AsyncValue<List<ProductModel?>>>((ref,) {
  return ProductManagementViewModel(ref);
});

class ProductManagementViewModel extends StateNotifier<AsyncValue<List<ProductModel?>>> {
  final Ref ref;
  ProductManagementViewModel(this.ref) : super(AsyncValue.loading());

  Future<void> getShopProduct(String id) async {
    try {
      List<ProductModel?> product = await ref.read(productProvider).getShopProduct(id);
      state = AsyncValue.data(product.isEmpty ? [] : product);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> getAllProduct(String category) async {
    try {
      state=AsyncValue.loading();
      List<ProductModel?> product = await ref.read(productProvider).getProduct(category);
      state = AsyncValue.data(product.isEmpty ? [] : product);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

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

  Future<void> deleteProduct(String id,String userId) async {
    try {
      state=AsyncValue.loading();
      await ref.read(productProvider).deleteProduct(id);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}