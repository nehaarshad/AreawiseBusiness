import 'dart:convert';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../View_Model/auth/sessionmanagementViewModel.dart';
import '../core/localDataSource/ordersLocalDataStorage.dart';
import '../core/network/appexception.dart';
import '../core/network/networkChecker.dart';
import '../core/services/app_APIs.dart';
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

  OrderLocalDataSource get _localDataSource => ref.read(ordersLocalDataSourceProvider);

  NetworkChecker get _networkChecker => ref.read(networkCheckerProvider);

  Future<List<OrdersRequestModel?>> fetchAndCacheSellerOrders() async {
     if(_localDataSource.hasSellerOrderCachedData()) {
       return _localDataSource.getSellerOrdersRequests();
     }
     return [];

  }

  Future<List<orderModel?>> fetchAndCacheCustomerOrders() async {
       if(_localDataSource.hasOrderHistoryCachedData()) {
         return _localDataSource.getCustomerOrdersHistory();
       }
       return [];

  }

  Future<List<OrdersRequestModel?>> getSellerOrders(String id)async{
    final isConnected = await _networkChecker.isConnected();
    if (isConnected) {
      List<OrdersRequestModel> orders;
      try {
        dynamic response = await apiservice.GetApiResponce(
            AppApis.getSellerOrderRequestsEndPoints.replaceFirst(':id', id),
            headers());
        if (response is List) {
          orders = response.map((order) =>
              OrdersRequestModel.fromJson(order as Map<String, dynamic>))
              .toList();
        }
       else{ orders = [OrdersRequestModel.fromJson(response)];}
       await _localDataSource.cacheAllSellerOrdersRequests(orders);
        return orders;
      } catch (e) {
        print(e);
        if (_localDataSource.hasSellerOrderCachedData()) {
          return _localDataSource.getSellerOrdersRequests();
        }
        throw NoInternetException('No internet and no cached data available');
      }
    }
    else{
      if (_localDataSource.hasSellerOrderCachedData()) {
        return _localDataSource.getSellerOrdersRequests();
      }
      throw NoInternetException('No internet and no cached data available');
    }
  }

  Future<List<orderModel?>> getCustomerOrders(String id)async{
    final isConnected = await _networkChecker.isConnected();
    if (isConnected) {
      List<orderModel> orders;
      try {
        dynamic response = await apiservice.GetApiResponce(
            AppApis.getCustomersOrdersEndPoints.replaceFirst(':id', id),
            headers());
        print(response);
        if (response is List) {
          orders = response.map((order) =>
              orderModel.fromJson(order as Map<String, dynamic>),).toList();
        }
       else{ orders = [orderModel.fromJson(response)];}
       await _localDataSource.cacheAllCustomerOrdersHistory(orders);
        return orders;
      } catch (e) {
        print(e);
        if (_localDataSource.hasOrderHistoryCachedData()) {
          return _localDataSource.getCustomerOrdersHistory();
        }
        throw NoInternetException('No internet and no cached data available');
      }
    }
    else{
      if (_localDataSource.hasOrderHistoryCachedData()) {
        return _localDataSource.getCustomerOrdersHistory();
      }
      throw NoInternetException('No internet and no cached data available');
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