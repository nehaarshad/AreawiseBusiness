import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/baseapiservice.dart';
import '../core/network/networkapiservice.dart';
import '../core/resources/app_APIs.dart';
import '../models/cartModel.dart';

final cartProvider=Provider<CartRepositories>((ref){
  return CartRepositories();
});

class CartRepositories{

  CartRepositories();
  baseapiservice apiservice=networkapiservice();

  Future<cartModel> addToCart(String id,int productId) async{
    try{
      final data = jsonEncode({
        'productId': productId,
      });
      final headers = {
        'Content-Type': 'application/json',
      };
      dynamic response=await apiservice.PostApiWithJson(AppApis.addToCartEndPoints.replaceFirst(':id', id), data,headers);
      if (response is Map<String, dynamic>) {
        return cartModel.fromJson(response);
      }
      throw Exception("invalid Response");
    }catch(e){
      throw e;
    }
  }

  Future<cartModel> getUserCart(String id) async{
    try{
      dynamic response=await apiservice.GetApiResponce(AppApis.getUserCartEndPoints.replaceFirst(':id', id));
      return cartModel.fromJson(response);
    }catch(e){
      throw e;
    }
  }

  Future<cartModel> updateCartItem(String id,int quantity) async{
    try{
      final data = jsonEncode({
        'quantity': quantity,
      });
      final headers = {
        'Content-Type': 'application/json',
      };
      dynamic response=await apiservice.UpdateApiWithJson(AppApis.getUserCartEndPoints.replaceFirst(':id', id),data,headers);
      return cartModel.fromJson(response);
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> deleteCartItem(String id) async{
    try{
      dynamic response=await apiservice.DeleteApiResponce(AppApis.deleteCartItemEndPoints.replaceFirst(':id', id));
      return response;
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> deleteUserCart(String id) async{
    try{
      dynamic response=await apiservice.DeleteApiResponce(AppApis.deleteCartofUserEndPoints.replaceFirst(':id', id));
      return response;
    }catch(e){
      throw e;
    }
  }

}