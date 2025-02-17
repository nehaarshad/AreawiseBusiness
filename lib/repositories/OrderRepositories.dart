import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/baseapiservice.dart';
import '../core/network/networkapiservice.dart';
import '../core/resources/app_APIs.dart';
import '../models/cartModel.dart';

final orderProvider = Provider<OrderRepositories>((ref) {
  return OrderRepositories();
});

class OrderRepositories {
  OrderRepositories();
  baseapiservice apiservice = networkapiservice();

  Future<dynamic> getUserCheckout(String id) async {
    try {
      dynamic response = await apiservice.GetApiResponce(
        AppApis.viewCheckOutEndPoints.replaceFirst(':id', id),
      );
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> placeUserOrder(String id, dynamic data) async {
    try {
      dynamic response = await apiservice.PostApiWithJson(
        AppApis.placeOrderEndPoints.replaceFirst(':id', id),
        data,
        {},
      );
      return response;
    } catch (e) {
      throw e;
    }
  }
}
