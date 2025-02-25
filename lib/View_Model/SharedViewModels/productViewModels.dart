

import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:ecommercefrontend/repositories/product_repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sharedProductViewModelProvider = StateNotifierProvider<sharedProductViewModel, AsyncValue<List<ProductModel?>>>((ref,) {
  return sharedProductViewModel(ref);
});

class sharedProductViewModel extends StateNotifier<AsyncValue<List<ProductModel?>>> {
  final Ref ref;
  sharedProductViewModel(this.ref) : super(AsyncValue.loading());

  Future<void> getShopProduct(String id) async {
    try {
      List<ProductModel?> product = await ref.read(productProvider).getShopProduct(id);
      state = AsyncValue.data(product.isEmpty ? [] : product);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> getUserProduct(String id) async {
    try {
      List<ProductModel?> product = await ref.read(productProvider).getUserProduct(id);
      state = AsyncValue.data(product.isEmpty ? [] : product);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> getAllProduct() async {
    try {
      List<ProductModel?> product = await ref.read(productProvider).getProduct();
      state = AsyncValue.data(product.isEmpty ? [] : product);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteProduct(String id,String userId) async {
    try {
      await ref.read(productProvider).deleteProduct(id);
      getUserProduct(userId);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}