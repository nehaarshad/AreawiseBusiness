import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/baseapiservice.dart';
import '../core/network/networkapiservice.dart';
import '../core/services/app_APIs.dart';
import '../models/cartModel.dart';

final cartProvider = Provider<CartRepositories>((ref) {
  return CartRepositories();
});

class CartRepositories {
  CartRepositories();
  baseapiservice apiservice = networkapiservice();

  Future<Cart> addToCart(String id, Map<String,dynamic> data) async {
    try {
      final headers = {'Content-Type': 'application/json'};
      final body=jsonEncode(data);
      dynamic response = await apiservice.PostApiWithJson(
        AppApis.addToCartEndPoints.replaceFirst(':id', id),
        body,
        headers,
      );
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
        AppApis.getUserCartEndPoints.replaceFirst(':id', id),
      );
      return Cart.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<Cart> updateCartItem(String id, int quantity) async {
    try {
      final data = jsonEncode({'quantity': quantity});
      final headers = {'Content-Type': 'application/json'};
      dynamic response = await apiservice.UpdateApiWithJson(
        AppApis.updateCartItemEndPoints.replaceFirst(':id', id),
        data,
        headers,
      );
      return Cart.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> deleteCartItem(String id) async {
    try {
      dynamic response = await apiservice.DeleteApiResponce(
        AppApis.deleteCartItemEndPoints.replaceFirst(':id', id),
      );
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> deleteUserCart(String id) async {
    try {
      dynamic response = await apiservice.DeleteApiResponce(
        AppApis.deleteCartofUserEndPoints.replaceFirst(':id', id),
      );
      return response;
    } catch (e) {
      throw e;
    }
  }
}
