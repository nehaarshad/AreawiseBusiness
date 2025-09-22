import 'package:ecommercefrontend/models/cartModel.dart';
import 'package:ecommercefrontend/repositories/cartRepositories.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter/material.dart';

import '../../core/utils/dialogueBox.dart';

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

  int cartItems=0;
  int get Items => cartItems;
  Future<Cart?> getUserCart(String id) async {
    try {
      Cart items = await ref.read(cartProvider).getUserCart(id);
      cartItems=items.cartItems?.length ?? 0;
      state = AsyncValue.data(items);
      // Notify listeners about cart items change
      ref.read(cartItemCountProvider.notifier).state = cartItems;

      return items;
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }

  //send id of item
  Future<void> deleteCartItem(String id,String userId,) async {
    try {
      dynamic items = await ref.read(cartProvider).deleteCartItem(id);
      print(items);
      await getUserCart(userId);
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  //send id of cart
  Future<void> deleteUserCart(String id,String userId, BuildContext context) async {
    try {
      dynamic items = await ref.read(cartProvider).deleteUserCart(id);
      await getUserCart(userId);
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<bool> addToCart(String id,int productId, int quantity,BuildContext context) async {
    try {
      final data={
        'productId':productId,
        'quantity':quantity,
      };
      await ref.read(cartProvider).addToCart(id, data);
      await getUserCart(id);
      await DialogUtils.showSuccessDialog(context, "Product added to cart successfully!");
      return true;
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.current);
      await DialogUtils.showErrorDialog(context, "Failed to add product!");
      return false;
    }
  }

  //send itemId as params, and product quantity as req.body
  Future<void> updateCartItem(String userId, String id, int data) async {
    try {
      await ref.read(cartProvider).updateCartItem(id, data);
      await getUserCart(userId);
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }



}

final cartItemCountProvider = StateProvider<int>((ref) => 0);