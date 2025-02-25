import 'package:ecommercefrontend/models/cartModel.dart';
import 'package:ecommercefrontend/repositories/cartRepositories.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter/material.dart';

final cartViewModelProvider =StateNotifierProvider.family<cartViewModel, AsyncValue<Cart?>, String>(
      (ref, id) {
        return cartViewModel(ref, id);
      },
    );

class cartViewModel extends StateNotifier<AsyncValue<Cart?>> {
  final Ref ref;
  String id;
  cartViewModel(this.ref, this.id) : super(AsyncValue.loading()) {
    getUserCart(id);
  }

  Future<void> getUserCart(String id) async {
    try {
      Cart items = await ref.read(cartProvider).getUserCart(id);
      state = AsyncValue.data(items);
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  //send id of item
  Future<void> deleteCartItem(String id) async {
    try {
      dynamic items = await ref.read(cartProvider).deleteCartItem(id);
      print(items);
      getUserCart(id);
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  //send id of cart
  Future<void> deleteUserCart(String id, BuildContext context) async {
    try {
      dynamic items = await ref.read(cartProvider).deleteUserCart(id);
      print(items);
      // state=AsyncValue.data(items);
      getUserCart(id);
      // Navigator.pop(context);
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  //send userId as params, and product id as req.body  //accesssd  on productdetailview
  Future<void> addToCart(String id, int data) async {
    try {
      Cart items = await ref.read(cartProvider).addToCart(id, data);
      if (kDebugMode) {
        print(items);
      }
      getUserCart(id);
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  //send itemId as params, and product quantity as req.body
  Future<void> updateCartItem(String userId, String id, int data) async {
    try {
      Cart items = await ref.read(cartProvider).updateCartItem(id, data);
      if (kDebugMode) {
        print(items);
      }
      getUserCart(userId);
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
