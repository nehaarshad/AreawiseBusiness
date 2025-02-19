import 'dart:convert';

import 'package:ecommercefrontend/models/orderModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/baseapiservice.dart';
import '../core/network/networkapiservice.dart';
import '../core/resources/app_APIs.dart';

final orderProvider = Provider<OrderRepositories>((ref) {
  return OrderRepositories();
});

class OrderRepositories {
  OrderRepositories();

  baseapiservice apiservice = networkapiservice();

  Future<orderModel> viewCheckOut(String id) async {
    try {
      dynamic response = await apiservice.GetApiResponce(AppApis.viewCheckOutEndPoints.replaceFirst(':id', id));
      return orderModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<orderModel> placeOrder(dynamic data) async {
    try {
     // final data = jsonEncode({'quantity': quantity});
      final headers = {'Content-Type': 'application/json'};
      dynamic response = await apiservice.PostApiWithJson(AppApis.placeOrderEndPoints,data,headers);
      return response;
    } catch (e) {
      throw e;
    }
  }

  // Future<dynamic> deleteAddress(dynamic data, String id) async {
  //   try {
  //     dynamic response = await apiservice.DeleteApiResponce(
  //       AppApis.DeleteUserAddressEndPoints.replaceFirst(':id', id),
  //     );
  //     return response;
  //   } catch (e) {
  //     throw e;
  //   }
  // }

}
