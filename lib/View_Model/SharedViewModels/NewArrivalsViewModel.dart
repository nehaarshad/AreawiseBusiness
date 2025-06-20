import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:ecommercefrontend/repositories/product_repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final newArrivalViewModelProvider = StateNotifierProvider<newArrivalViewModel, AsyncValue<List<ProductModel?>>>((ref,) {
  return newArrivalViewModel(ref);
});

class newArrivalViewModel extends StateNotifier<AsyncValue<List<ProductModel?>>> {
  final Ref ref;
  newArrivalViewModel(this.ref) : super(AsyncValue.loading()){
    getNewArrivalProduct("All");
  }


  Future<void> getNewArrivalProduct(String category) async {
    try {
      List<ProductModel?> product = await ref.read(productProvider).getNewArrivalProduct(category);
      state = AsyncValue.data(product.isEmpty ? [] : product);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

}