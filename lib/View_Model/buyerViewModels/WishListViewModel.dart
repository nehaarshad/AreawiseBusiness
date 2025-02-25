import 'package:ecommercefrontend/models/wishListModel.dart';
import 'package:ecommercefrontend/repositories/wishListRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wishListViewModelProvider=StateNotifierProvider.family<wishListViewModel,AsyncValue<List<wishListModel?>>,String>((ref,id){
  return wishListViewModel(ref: ref,id: id);
});

class wishListViewModel extends StateNotifier<AsyncValue<List<wishListModel?>>>{
  final Ref ref;
  String id;
  wishListViewModel({required this.ref,required this.id}):super(AsyncValue.loading()){
    getUserWishList(id);
  }

  Future<void> addToWishList(String id,int ProductId) async {
    try {
      await ref.read(wishListProvider).addToWishList(id,ProductId);
      ref.invalidate(wishListViewModelProvider(id));
      await ref.read(wishListViewModelProvider(id).notifier).getUserWishList(id);
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> getUserWishList(String id) async {
    try {
      List<wishListModel?> items = await ref.read(wishListProvider).getUserWishList(id);
      state = AsyncValue.data(items);
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteItemFromWishList(String id,int productId) async {
    try {
      await ref.read(wishListProvider).removeItemFromWishList(id, productId);
      getUserWishList(id);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

}