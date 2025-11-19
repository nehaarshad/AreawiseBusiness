import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../View_Model/auth/sessionmanagementViewModel.dart';
import '../core/network/baseapiservice.dart';
import '../core/network/networkapiservice.dart';
import '../core/network/app_APIs.dart';
import '../models/cartModel.dart';

final cartProvider = Provider<CartRepositories>((ref) {
  return CartRepositories(ref: ref);
});

class CartRepositories {
  Ref  ref;
  CartRepositories({required this.ref});
  baseapiservice apiservice = networkapiservice();


  Map<String, String> headers() {
    final token = ref.read(sessionProvider)?.token;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
  Future<Cart> addToCart(String id, Map<String,dynamic> data,) async {
    try {

      final body=jsonEncode(data);
      dynamic response = await apiservice.PostApiWithJson(
        AppApis.addToCartEndPoints.replaceFirst(':id', id),
        body,
          headers(),
      );
      print("addToCart repository: ${response}");
      if (response is Map<String, dynamic>) {
        return Cart.fromJson(response);
      }
      throw Exception("invalid Response");
    } catch (e) {
      throw e;
    }
  }

  Future<Cart> getUserCart(String id) async {
    try {

      dynamic response = await apiservice.GetApiResponce(
        AppApis.getUserCartEndPoints.replaceFirst(':id', id), headers(),
      );
      return Cart.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<Cart> updateCartItem(String id, int quantity,) async {
    try {
      final data = jsonEncode({'quantity': quantity});

      dynamic response = await apiservice.UpdateApiWithJson(
        AppApis.updateCartItemEndPoints.replaceFirst(':id', id),
        data,
          headers(),
      );
      return Cart.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> deleteCartItem(String id) async {
    try {
      dynamic response = await apiservice.DeleteApiResponce(
        AppApis.deleteCartItemEndPoints.replaceFirst(':id', id), headers(),
      );
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> deleteUserCart(String id) async {
    try {
      dynamic response = await apiservice.DeleteApiResponce(
        AppApis.deleteCartofUserEndPoints.replaceFirst(':id', id), headers(),
      );
      return response;
    } catch (e) {
      throw e;
    }
  }
}
