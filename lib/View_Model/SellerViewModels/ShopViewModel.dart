import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../models/shopModel.dart';
import '../../repositories/ShopRepositories.dart';

final shopViewModelProvider = StateNotifierProvider.family<
  shopsViewModel,
  AsyncValue<List<ShopModel?>>,
  String
>((ref, id) {
  return shopsViewModel(ref, id);
});

class shopsViewModel extends StateNotifier<AsyncValue<List<ShopModel?>>> {
  final Ref ref;
  String id;
  shopsViewModel(this.ref, this.id) : super(const AsyncValue.loading()) {
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
      getShops(id); //Rerender Ui or refetch shops if shop deleted
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
