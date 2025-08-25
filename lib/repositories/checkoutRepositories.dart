import 'dart:convert';

import 'package:ecommercefrontend/models/orderModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../View_Model/auth/sessionmanagementViewModel.dart';
import '../core/network/baseapiservice.dart';
import '../core/network/networkapiservice.dart';
import '../core/services/app_APIs.dart';
import '../models/cartModel.dart';
import '../models/paymentModel.dart';

final orderProvider = Provider<OrderRepositories>((ref) {
  return OrderRepositories(ref);
});

class OrderRepositories {
  Ref ref;
  OrderRepositories(this.ref);

  baseapiservice apiservice = networkapiservice();

  Map<String, String> headers() {
    final token = ref.read(sessionProvider)?.token;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
  Future<List<paymentModel>> getUserCheckout(String id,Map<String,dynamic> data) async {
    try {
      List<paymentModel> paymentlist = [];
      final body=jsonEncode(data);
      dynamic response = await apiservice.PostApiWithJson(
        AppApis.viewCheckOutEndPoints.replaceFirst(':id', id),body,headers()
      );
      if (response is List) {
        return response.map((products) =>
            paymentModel.fromJson(products as Map<String, dynamic>),)
            .toList();
      }
      paymentlist = [paymentModel.fromJson(response)];
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<Cart> cancelOrder(String id) async {
    try {
      dynamic response = await apiservice.UpdateApiWithJson(
        AppApis.updateCartEndPoints.replaceFirst(':id', id),null,headers()
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
      dynamic response = await apiservice.PostApiWithJson(AppApis.placeOrderEndPoints, requestData, headers(),);
      return orderModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
