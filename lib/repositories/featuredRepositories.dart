import 'dart:convert';

import 'package:ecommercefrontend/models/featureModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:riverpod/riverpod.dart';

import '../View_Model/auth/sessionmanagementViewModel.dart';
import '../core/localDataSource/productLocalSource.dart';
import '../core/network/appexception.dart';
import '../core/network/networkChecker.dart';
import '../core/services/app_APIs.dart';
import '../models/ProductModel.dart';

final featureProvider = Provider<featureRepositories>((ref) {
  return featureRepositories(ref);
});

class featureRepositories {
  Ref ref;

  featureRepositories(this.ref);

  baseapiservice apiservice = networkapiservice();
  Map<String, String> headers() {
    final token = ref.read(sessionProvider)?.token;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  ProductLocalDataSource get _localDataSource => ref.read(productLocalDataSourceProvider);

  NetworkChecker get _networkChecker => ref.read(networkCheckerProvider);

  Future<List<featureModel>> fetchAndCacheFeaturedProducts() async {

    if(_localDataSource.hasFeaturedProductCachedData()) {
      return _localDataSource.getFeaturedProductsByCategory('All');
    }
    return [];

  }

  Future<featureModel> createProductFeatured(String id, Map<String, dynamic> request) async {
    try {
      final data = jsonEncode(request);
      dynamic response = await apiservice.PostApiWithJson(AppApis.createProductFeaturedEndPoints.replaceFirst(':id', id), data, headers());
      if (response is Map<String, dynamic>) {
        return featureModel.fromJson(response);
      }
      throw Exception("invalid Response");
    } catch (e) {
      throw e;
    }
  }

  Future<List<featureModel?>> getSellerFeaturedProducts(String id)async{
    final isConnected = await _networkChecker.isConnected();
    if (isConnected) {
      List<featureModel> orders;
      try {
        dynamic response = await apiservice.GetApiResponce(
            AppApis.getUserFeaturedProductsEndPoints.replaceFirst(':id', id),
            headers());
        if (response is List) {
          return response.map((order) =>
              featureModel.fromJson(order as Map<String, dynamic>)).toList();
        }
        orders = [featureModel.fromJson(response)];
        return orders;
      } catch (e) {
        print(e);
        if (_localDataSource.hasFeaturedProductCachedData()) {
          int? sellerId = int.tryParse(id);
          if(sellerId != null) {
            return _localDataSource.getSellerFeaturesProducts(sellerId);
          }
        }
        throw NoInternetException('No internet and no cached data available');

      }
    }
    else{
      if (_localDataSource.hasFeaturedProductCachedData()) {
        int? sellerId = int.tryParse(id);
        if(sellerId != null) {
          return _localDataSource.getSellerFeaturesProducts(sellerId);
        }
      }
      throw NoInternetException('No internet and no cached data available');
    }
  }

  Future<List<featureModel?>> getAllFeaturedProducts(String category)async{
    final isConnected = await _networkChecker.isConnected();
    if (isConnected) {
      List<featureModel> orders;
      try {
        dynamic response = await apiservice.GetApiResponce(
            AppApis.getAllFeaturedProductsEndPoints.replaceFirst(
                ':Category', category), headers());
        if (response is List) {
          orders = response.map((order) =>
              featureModel.fromJson(order as Map<String, dynamic>),).toList();
        }
        else {
          orders = [featureModel.fromJson(response)];
        }
        if(category=="All"){
          await _localDataSource.cacheFeaturedProducts(orders);
        }
        return orders;
      } catch (e) {
        print(e);
        if(_localDataSource.hasFeaturedProductCachedData()){
          return _localDataSource.getFeaturedProductsByCategory(category);
        }
        throw NoInternetException("No Internet Connection");
      }
    }
    else{
      if(_localDataSource.hasFeaturedProductCachedData()){
        return _localDataSource.getFeaturedProductsByCategory(category);
      }
      throw NoInternetException("No Internet Connection");
    }
  }

  Future<List<featureModel?>> getAllRequestedFeaturedProducts()async{
    final isConnected = await _networkChecker.isConnected();
    if (isConnected) {
      List<featureModel> orders;
      try {
        dynamic response = await apiservice.GetApiResponce(
            AppApis.getAllRequestedFeaturedProductsEndPoints, headers());
        if (response is List) {
          return response.map((order) =>
              featureModel.fromJson(order as Map<String, dynamic>),).toList();
        }
        orders = [featureModel.fromJson(response)];
        return orders;
      } catch (e) {
        print(e);
        if (_localDataSource.hasFeaturedProductCachedData()) {
          return _localDataSource.getRequestedFeaturedProducts();
        }
        throw NoInternetException('No internet and no cached data available');
      }
    }
    else {
      if (_localDataSource.hasFeaturedProductCachedData()) {
        return _localDataSource.getRequestedFeaturedProducts();
      }
      throw NoInternetException('No internet and no cached data available');
    }
  }

  Future<featureModel> updateFeaturedProducts(String id,  Map<String,dynamic>  status) async {
    try {
      print(id);
      final responseData=jsonEncode(status);
      dynamic response = await apiservice.UpdateApiWithJson(AppApis.updateFeaturedProductsEndPoints.replaceFirst(':id', id), responseData, headers(),);
      return featureModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteFeaturedProducts(String id)async{

    try{
      dynamic response=await apiservice.DeleteApiResponce(AppApis.deleteFeaturedProductsEndPoints.replaceFirst(':id', id),headers());

      return response;
    }catch(e){
      rethrow;
    }
  }

}
