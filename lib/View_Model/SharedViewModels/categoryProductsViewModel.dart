import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:ecommercefrontend/repositories/product_repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final CategoryProductViewModelProvider = StateNotifierProvider.family<CategoryProductViewModel, AsyncValue<List<ProductModel?>>,String>((ref,name) {
  return CategoryProductViewModel(ref,name);
});

class CategoryProductViewModel extends StateNotifier<AsyncValue<List<ProductModel?>>> {
  final Ref ref;
  final String name;
  CategoryProductViewModel(this.ref,this.name) : super(AsyncValue.loading()){
    getCategoryProduct(this.name);
  }


  Future<void> getCategoryProduct(String name) async {
    try {
      List<ProductModel?> product = await ref.read(productProvider).getProduct(name);
      state = AsyncValue.data(product.isEmpty ? [] : product);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

}