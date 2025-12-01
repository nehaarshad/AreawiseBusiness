import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:ecommercefrontend/repositories/product_repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ProductDetailsViewModelProvider = StateNotifierProvider.family<ProductDetailsViewModel, AsyncValue<ProductModel?>,String>((ref,id) {
  return ProductDetailsViewModel(ref,id);
});

class ProductDetailsViewModel extends StateNotifier<AsyncValue<ProductModel?>> {
  final Ref ref;
  String id;
  ProductDetailsViewModel(this.ref,this.id) : super(AsyncValue.loading()){

  }

  Future<ProductModel?> getProductDetails(String id,String userId) async {
    try {
      ProductModel? product = await ref.read(productProvider)
          .getProductByID(id,userId);
      state = AsyncValue.data(product);
      return product;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }


}