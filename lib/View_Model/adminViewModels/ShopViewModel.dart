import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/shopModel.dart';
import '../../repositories/ShopRepositories.dart';
import '../SellerViewModels/sellerShopViewModel.dart';
import '../SharedViewModels/allShopsViewModel.dart';
import '../SharedViewModels/getAllCategories.dart';

//for admin to view and delete shops
final shopViewModelProvider =
    StateNotifierProvider<shopsViewModel, AsyncValue<List<ShopModel?>>>((ref) {
      return shopsViewModel(ref);
    });

class shopsViewModel extends StateNotifier<AsyncValue<List<ShopModel?>>> {
  final Ref ref;

  shopsViewModel(this.ref) : super(const AsyncValue.loading()) {
    getShops();
  }

  Future<void> getShops() async {
    try {
      List<ShopModel?> shoplist = await ref.read(shopProvider).getAllShops();
      state = AsyncValue.data(shoplist.isEmpty ? [] : shoplist);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteShop(String id,String userId) async {
    try {
      await ref.read(shopProvider).deleteShop(id);
      getShops(); //Rerender Ui or refetch shops if shop deleted
      ref.invalidate(sellerShopViewModelProvider(userId.toString()));
      ref.invalidate(allShopViewModelProvider);
      await ref.read(sellerShopViewModelProvider(userId.toString()).notifier).getShops(userId.toString());
      await ref.read(allShopViewModelProvider.notifier).getAllShops();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateShopStatus(String id,String userId,String status) async {
    try {
      await ref.read(shopProvider).updateShopStatus(id,status);
      getShops();
      ref.invalidate(sellerShopViewModelProvider(userId.toString()));
      ref.invalidate(allShopViewModelProvider);
      await ref.read(sellerShopViewModelProvider(userId.toString()).notifier).getShops(userId.toString());
      await ref.read(allShopViewModelProvider.notifier).getAllShops();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }


}
