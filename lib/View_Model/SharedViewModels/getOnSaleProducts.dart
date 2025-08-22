import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:ecommercefrontend/repositories/product_repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final onSaleViewModelProvider = StateNotifierProvider<onSaleViewModel, AsyncValue<List<ProductModel?>>>((ref,) {
  return onSaleViewModel(ref);
});

class onSaleViewModel extends StateNotifier<AsyncValue<List<ProductModel?>>> {
  final Ref ref;
  onSaleViewModel(this.ref) : super(AsyncValue.loading());


  Future<void> getonSaleProduct(String category) async {
    try {
      List<ProductModel?> product = await ref.read(productProvider).getOnSaleProducts(category);
      state = AsyncValue.data(product.isEmpty ? [] : product);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

}