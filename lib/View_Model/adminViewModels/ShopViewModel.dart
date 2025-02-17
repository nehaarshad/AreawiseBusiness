import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/shopModel.dart';
import '../../repositories/ShopRepositories.dart';

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

  Future<void> deleteShop(String id) async {
    try {
      await ref.read(shopProvider).deleteShop(id);
      getShops(); //Rerender Ui or refetch shops if shop deleted
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
