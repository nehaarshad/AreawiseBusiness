import 'dart:convert';

import 'package:ecommercefrontend/models/orderModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/baseapiservice.dart';
import '../core/network/networkapiservice.dart';
import '../core/services/app_APIs.dart';
import '../models/cartModel.dart';

final orderProvider = Provider<OrderRepositories>((ref) {
  return OrderRepositories();
});

class OrderRepositories {
  OrderRepositories();
  baseapiservice apiservice = networkapiservice();

  Future<orderModel> getUserCheckout(String id) async {
    try {
      dynamic response = await apiservice.GetApiResponce(
        AppApis.viewCheckOutEndPoints.replaceFirst(':id', id),
      );
      return orderModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<Cart> cancelOrder(String id) async {
    try {
      final headers = {'Content-Type': 'application/json'};
      dynamic response = await apiservice.UpdateApiWithJson(
        AppApis.updateCartEndPoints.replaceFirst(':id', id),null,headers
      );
      return Cart.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<orderModel> placeUserOrder(Map<String,dynamic> data) async {
    try {
      print('API Request Data: ${jsonEncode(data)}');
      final requestData = jsonEncode(data);
      print('Request Data: ${requestData}');
      final headers = {'Content-Type': 'application/json'};
      dynamic response = await apiservice.PostApiWithJson(AppApis.placeOrderEndPoints, requestData, headers,);
      return orderModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
