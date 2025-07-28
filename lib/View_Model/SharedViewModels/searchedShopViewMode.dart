import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/shopModel.dart';
import '../../repositories/ShopRepositories.dart';

final searchShopViewModelProvider = StateNotifierProvider<searchShopsViewModel, AsyncValue<List<ShopModel?>>>((ref) {
  return searchShopsViewModel(ref);
});

class searchShopsViewModel extends StateNotifier<AsyncValue<List<ShopModel?>>> {
  final Ref ref;
  searchShopsViewModel(this.ref, ) : super(const AsyncValue.loading());

  Future<void> searchShops(String name) async {
    try {
      List<ShopModel?> shoplist = await ref.read(shopProvider).searchShop(name);
      state = AsyncValue.data(shoplist.isEmpty ? [] : shoplist);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

}