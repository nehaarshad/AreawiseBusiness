import 'dart:convert';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../View_Model/auth/sessionmanagementViewModel.dart';
import '../core/network/app_APIs.dart';
import '../models/orderModel.dart';
import '../models/ordersRequestModel.dart';

final sellerOrderProvider=Provider<sellerOrderRepository>((ref){
  return sellerOrderRepository(ref);
});

class sellerOrderRepository{
  Ref ref;
  sellerOrderRepository(this.ref);
  baseapiservice apiservice=networkapiservice();

  Map<String, String> headers() {
    final token = ref
        .read(sessionProvider)
        ?.token;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
  Future<List<OrdersRequestModel?>> getSellerOrders(String id)async{
    List<OrdersRequestModel> orders;
    try{
      dynamic response=await apiservice.GetApiResponce(AppApis.getSellerOrderRequestsEndPoints.replaceFirst(':id', id),headers());
      if (response is List) {
        return response.map((order) => OrdersRequestModel.fromJson(order as Map<String, dynamic>)).toList();
      }
      orders = [OrdersRequestModel.fromJson(response)];
      return orders;
    }catch(e){
      rethrow;
    }
  }

  Future<List<orderModel?>> getCustomerOrders(String id)async{
    List<orderModel> orders;
    try{
      dynamic response=await apiservice.GetApiResponce(AppApis.getCustomersOrdersEndPoints.replaceFirst(':id', id),headers());
     print(response);
      if (response is List) {
        return response.map((order) => orderModel.fromJson(order as Map<String, dynamic>),).toList();
      }
      orders = [orderModel.fromJson(response)];
      return orders;
    }catch(e){
      rethrow;
    }
  }

  Future<OrdersRequestModel> updateOrderStatus(String id, Map<String,dynamic> data) async {
    try {
      final responseData=jsonEncode(data);
      dynamic response = await apiservice.UpdateApiWithJson(AppApis.updateSellerOrderRequestsStatusEndPoints.replaceFirst(':id', id), responseData, headers(),);
      return OrdersRequestModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

}