import 'dart:convert';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/resources/app_APIs.dart';
import '../models/ordersRequestModel.dart';

final sellerOrderProvider=Provider<sellerOrderRepository>((ref){
  return sellerOrderRepository();
});

class sellerOrderRepository{
  sellerOrderRepository();
  baseapiservice apiservice=networkapiservice();

  Future<List<OrdersRequestModel?>> getSellerOrders(String id)async{
    List<OrdersRequestModel> orders;
    try{
      dynamic response=await apiservice.GetApiResponce(AppApis.getSellerOrderRequestsEndPoints.replaceFirst(':id', id));
      if (response is List) {
        return response.map((order) => OrdersRequestModel.fromJson(order as Map<String, dynamic>)).toList();
      }
      orders = [OrdersRequestModel.fromJson(response)];
      return orders;
    }catch(e){
      rethrow;
    }
  }

  Future<List<OrdersRequestModel?>> getCustomerOrders(String id)async{
    List<OrdersRequestModel> orders;
    try{
      dynamic response=await apiservice.GetApiResponce(AppApis.getCustomersOrdersEndPoints.replaceFirst(':id', id));
      if (response is List) {
        return response.map((order) => OrdersRequestModel.fromJson(order as Map<String, dynamic>),).toList();
      }
      orders = [OrdersRequestModel.fromJson(response)];
      return orders;
    }catch(e){
      rethrow;
    }
  }

  Future<OrdersRequestModel> updateOrderStatus(String id, Map<String,dynamic> data) async {
    try {
      final responseData=jsonEncode(data);
      final headers = {'Content-Type': 'application/json'};
      dynamic response = await apiservice.UpdateApiWithJson(AppApis.updateSellerOrderRequestsStatusEndPoints.replaceFirst(':id', id), responseData, headers,);
      return OrdersRequestModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

}