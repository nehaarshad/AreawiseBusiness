import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/product_repositories.dart';

final deleteProductProvider = FutureProvider.family<dynamic, String>((
  ref,
  id,
) async {
  dynamic deleteproduct = await ref.read(productProvider).deleteProduct(id);
  return deleteproduct;
});

final getAllProductProvider = FutureProvider<List<ProductModel?>>((ref) async {
  List<ProductModel?> getallproducts =
      await ref.read(productProvider).getProduct();
  return getallproducts;
});

final getUserProductProvider =
    FutureProvider.family<List<ProductModel?>, String>((ref, id) async {
      List<ProductModel?> getuserproducts = await ref
          .read(productProvider)
          .getUserProduct(id);
      return getuserproducts;
    });

final getShopProductProvider =
    FutureProvider.family<List<ProductModel?>, String>((ref, id) async {
      List<ProductModel?> getshopproducts = await ref
          .read(productProvider)
          .getShopProduct(id);
      return getshopproducts;
    });

/// class ProductViewModel extends StateNotifier<AsyncValue<List<ProductModel?>>>{
///   final Ref ref;
///  ProductViewModel (this.ref):super(AsyncValue.loading());
///
///    Future<void> AllProducts() async{
///     try {
///       List<ProductModel> productlist = await ref.read(productProvider).getProduct();
///      state = AsyncValue.data(productlist.isEmpty ? [] : productlist);
///     }catch(e){
///       state=AsyncValue.error(e, StackTrace.current);
///     }
///    }
///
///    Future<void> UserProducts(String id) async{
///      try{
///        List<ProductModel> productlist = await ref.read(productProvider).getUserProduct(id);
///        state = AsyncValue.data(productlist.isEmpty ? [] : productlist);
///      }catch(e){
///        state=AsyncValue.error(e, StackTrace.current);
///      }
///    }
///
///    Future<void> ShopProducts(String id) async{
///      try{
///        List<ProductModel> productlist = await ref.read(productProvider).getShopProduct(id);
///        state = AsyncValue.data(productlist.isEmpty ? [] : productlist);
///      }catch(e){
///        state=AsyncValue.error(e, StackTrace.current);
///      }
///    }
///
/// }wwee
