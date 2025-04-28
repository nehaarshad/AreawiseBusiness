import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/shopModel.dart';
import '../../repositories/ShopRepositories.dart';

final allShopViewModelProvider = StateNotifierProvider<allShopsViewModel, AsyncValue<List<ShopModel?>>>((ref) {
  return allShopsViewModel(ref);
});

class allShopsViewModel extends StateNotifier<AsyncValue<List<ShopModel?>>> {
  final Ref ref;
  allShopsViewModel(this.ref, ) : super(const AsyncValue.loading()) {
    getAllShops();
  }

  Future<void> getAllShops() async {
    try {
      List<ShopModel?> shoplist = await ref.read(shopProvider).getAllShops();
      state = AsyncValue.data(shoplist.isEmpty ? [] : shoplist);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }


}