import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:ecommercefrontend/repositories/product_repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subCategoryProductViewModelProvider = StateNotifierProvider.family<subCategoryProductViewModel, AsyncValue<List<ProductModel?>>,String>((ref,name) {
  return subCategoryProductViewModel(ref,name);
});

class subCategoryProductViewModel extends StateNotifier<AsyncValue<List<ProductModel?>>> {
  final Ref ref;
  final String name;
  subCategoryProductViewModel(this.ref,this.name) : super(AsyncValue.loading()){
    getsubCategoryProduct(this.name);
  }


  Future<void> getsubCategoryProduct(String name) async {
    try {
      List<ProductModel?> product = await ref.read(productProvider).getProductsBySubcategory(name);
      state = AsyncValue.data(product.isEmpty ? [] : product);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

}