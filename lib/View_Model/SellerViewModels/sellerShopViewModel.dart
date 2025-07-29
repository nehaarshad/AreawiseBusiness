import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/shopModel.dart';
import '../../repositories/ShopRepositories.dart';
import '../adminViewModels/ShopViewModel.dart';

//for seller to get and delete its shops
final sellerShopViewModelProvider = StateNotifierProvider.family<sellerShopsViewModel, AsyncValue<List<ShopModel?>>, String>((ref, id) {
  return sellerShopsViewModel(ref, id);
});

class sellerShopsViewModel extends StateNotifier<AsyncValue<List<ShopModel?>>> {
  final Ref ref;
  String id;
  sellerShopsViewModel(this.ref, this.id) : super(const AsyncValue.loading()) {
    getShops(id);
  }

  Future<void> getShops(String id) async {
    try {
      List<ShopModel?> shoplist = await ref.read(shopProvider).getUserShop(id);
      state = AsyncValue.data(shoplist.isEmpty ? [] : shoplist);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteShop(String id) async {
    try {
      await ref.read(shopProvider).deleteShop(id);
      await getShops(this.id); //Rerender Ui or refetch shops if shop deleted
      ref.invalidate(shopViewModelProvider);///refetch all shops when owner delete its any shop
      await ref.read(shopViewModelProvider.notifier).getShops();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
