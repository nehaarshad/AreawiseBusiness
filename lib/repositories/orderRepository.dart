import 'package:ecommercefrontend/models/orderModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../View_Model/auth/sessionmanagementViewModel.dart';
import '../core/network/baseapiservice.dart';
import '../core/network/networkapiservice.dart';
import '../core/services/app_APIs.dart';

final orderProvider = Provider<OrderRepositories>((ref) {
  return OrderRepositories(ref);
});

class OrderRepositories {
  Ref ref;
  OrderRepositories(this.ref);
  Map<String, String> headers() {
    final token = ref.read(sessionProvider)?.token;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
  baseapiservice apiservice = networkapiservice();

  Future<orderModel> viewCheckOut(String id) async {
    try {
      dynamic response = await apiservice.GetApiResponce(AppApis.viewCheckOutEndPoints.replaceFirst(':id', id),headers());
      return orderModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<orderModel> placeOrder(dynamic data) async {
    try {
     // final data = jsonEncode({'quantity': quantity});
      dynamic response = await apiservice.PostApiWithJson(AppApis.placeOrderEndPoints,data,headers());
      return response;
    } catch (e) {
      throw e;
    }
  }

}
